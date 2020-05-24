#!/usr/bin/env python3

import asyncio
import argparse
from dataclasses import dataclass
import enum
import functools
import os
from pathlib import Path
import shlex
import subprocess
import sys
from typing import Optional


MAX_JOBS = 4


PREPUSH_HEADER = """
#!/usr/bin/env bash
"""
PREPUSH_BODY = """
cd "${check_path}"

red=$'\e[31m'
bold=$'\e[1m'
nobold=$'\e[22m'
norm=$'\e[0m'

# check if there are any untracked/not committed/etc files in the
# local repo first (fastest to check fail case)

if [[ -n "$(git status --porcelain)" ]]; then
    echo "${red}!! ${bold}${check_path}${nobold} has changes that are not checked in${norm}" >&2
    git status -u
    exit 1
fi

# check if the remote git repo is different from the local clone
# this calls out to the network but that is acceptable in this context
# since you cannot deploy without network access

# source: https://stackoverflow.com/a/17938274
git fetch
if [[ ! $(git rev-parse HEAD) == $(git rev-parse @{u}) ]]; then
    echo "${red}!! ${bold}${check_path}${nobold} is not the same as remote${norm}" >&2
    git status -u
    exit 1
else
    exit 0
fi
"""


def make_prepush_check_pulled(d):
    """
    Makes a prepush script that checks that a repo at relative path `d` is up
    to date.
    """
    return PREPUSH_HEADER + f'\n\ncheck_path={shlex.quote(d)}\n\n' + PREPUSH_BODY


def eprint(*args, **kwargs):
    """
    Print to stderr with the same arguments as `print()`.
    """
    print(*args, file=sys.stderr, **kwargs)


def whereami():
    """
    Returns the path to where we are installed
    """
    return Path(__file__).parent


@dataclass
class Config:
    """
    Tool configuration.
    """
    check_pulled: Optional[str] = None


async def exec_n(coro, semaphore):
    """
    Await a result, limited to a certain number in parallel by a semaphore.
    """
    async with semaphore:
        return await coro


def get_repos():
    """
    Makes a `(config, list of repos)` tuple from the config file.
    """
    configfile = whereami() / 'repos.txt'
    config = Config()
    repos = []
    with configfile.open('r') as h:
        for line in h.readlines():
            stripped = line.strip()
            if stripped == '' or stripped.startswith('#'):
                # ignore empty lines and comments
                continue

            if stripped.startswith('!'):
                # config option
                opt, _, val = stripped.partition(' ')
                if hasattr(config, opt[1:]):
                    setattr(config, opt[1:], val)
                else:
                    eprint(f'Unknown option {bold(opt[1:])}')
                continue

            # split off local part
            url, _, name = stripped.partition(' ')
            repos.append((url, name))
    return (config, repos)


class RepoStatus(enum.Enum):
    """
    A state a repo can have with relation to its upstream.
    """
    UNTRACKED    = enum.auto()
    UP_TO_DATE   = enum.auto()
    REMOTE_AHEAD = enum.auto()
    LOCAL_AHEAD  = enum.auto()
    UNKNOWN      = enum.auto()


async def get_status(repo):
    """
    Return whether a given repo is up to date, behind, or has untracked files.
    Relies on you being in the whereami() directory.
    """
    status = await gitcmd(['status', '--porcelain'], chdir=repo, err_ok=True)
    if status != 0:
        # git status returns nonzero if there are untracked files
        return RepoStatus.UNTRACKED

    status = await gitcmd(['fetch', '--quiet'], chdir=repo, err_ok=False)
    if status != 0:
        # Ignore errors and just fail to find status if we can't contact remote
        return RepoStatus.UNKNOWN

    local_is_ancestor, remote_is_ancestor = await asyncio.gather(
        gitcmd(['merge-base', '--is-ancestor', 'HEAD', '@{u}'],
                chdir=repo, err_ok=True),
        gitcmd(['merge-base', '--is-ancestor', '@{u}', 'HEAD'],
                chdir=repo, err_ok=True)
    )

    if remote_is_ancestor == 0 and local_is_ancestor == 0:
        # if both of them are ancestors of themselves then they are the same
        # commit
        return (repo, RepoStatus.UP_TO_DATE)
    elif remote_is_ancestor == 1 and local_is_ancestor == 0:
        # remote is NOT ancestor of local but local is ancestor of remote
        # This means that local is ahead.
        return (repo, RepoStatus.REMOTE_AHEAD)
    elif remote_is_ancestor == 0 and local_is_ancestor == 1:
        # remote is ancestor of local and local is NOT ancestor of remote
        # This means that remote is ahead
        return (repo, RepoStatus.LOCAL_AHEAD)
    else:
        return (repo, RepoStatus.UNKNOWN)



async def run_cmd(executable, cmd, cb = lambda *_: None,
                  chdir = None, err_ok = False):
    """
    Runs the given `executable` with `cmd` list of arguments. Calls the `cb`
    callback with `cmd`, `chdir` and the return code of the command as
    arguments.

    Changes directory to `chdir` before running the command if given.

    Reports errors to stderr if `err_ok` is False.

    Returns the return code of the process execution.
    """
    #eprint('Executing', *cmd, 'in', chdir)
    proc = await asyncio.create_subprocess_exec(executable, *cmd, cwd=chdir)
    retcode = await proc.wait()
    if retcode != 0 and not err_ok:  # not EXIT_SUCCESS
        eprint('Command', bold(' '.join((executable, *cmd))),
                'in', bold(chdir), 'exited with a failure status code',
                retcode)
    cb(cmd, chdir, retcode)
    return retcode


gitcmd = functools.partial(run_cmd, 'git')


def update_gitignore(repos):
    """
    Adds all the repositories to gitignore idempotently if installed in the
    root of a git repo
    """
    SIGNATURE = b'### AUTOGENERATED ignores from repo.py, content below ' \
                b'*will* be overwritten ###\n'
    cwd = whereami()
    if not (cwd / '.git').is_dir():
        # we are not in the root of a git working tree, don't screw it up
        return

    # we have to open this file in binary format because of the extremely
    # surprising behaviour described in https://bugs.python.org/issue26158
    with open('.gitignore', 'rb+') as h:
        need_sig = True

        # move the position in the stream to after our signature
        while True:
            line = h.readline()
            if line == b'':
                break
            if line == SIGNATURE:
                need_sig = False
                break

        h.truncate(h.tell())
        if need_sig:
            h.write(SIGNATURE)
        for repo in repos:
            h.write(repo[1].encode() + b'/\n')


def add_exec_bit(st_mode):
    """
    Adds the executable bit to a file mode.
    """
    # remove the file type field from the mode
    perms = st_mode & ((1 << 9) - 1)
    # put the executable bit in each of the three spots
    perms |= 0o111
    return perms


async def cli_init(args):
    github_url = 'https://github.com/' if args.https else 'git@github.com:'

    config, repos = get_repos()
    update_gitignore(repos)

    total = len(repos)
    eprint(f"Initializing {total} repos")
    os.chdir(whereami())
    done = 0

    def finished(*_):
        nonlocal done
        done += 1
        eprint(f"Completed {done}/{total}")

    async def clone(url, directory):
        # clone the repo
        exitcode = await gitcmd(['clone', '--quiet', url, directory],
                     cb=finished)
        # insert pre-push hook if we are not processing that repo itself
        if exitcode == 0 and config.check_pulled \
                and directory != config.check_pulled:
            check_relpath = os.path.relpath(
                    Path(config.check_pulled).resolve(),
                         start=Path(directory).resolve())
            script_path = Path(directory) / '.git/hooks/pre-push'

            # write out the templated script
            with open(script_path, 'w') as h:
                h.write(make_prepush_check_pulled(check_relpath))
            # chmod a+x
            stat = script_path.stat()
            script_path.chmod(add_exec_bit(stat.st_mode))
        eprint(f'Cloned {bold(directory)}')

    semaphore = asyncio.Semaphore(MAX_JOBS)
    jobs = []
    for (gh, directory) in repos:
        # Don't clone repos that exist
        if Path(directory).exists():
            finished()
            eprint(f'Skipping already initialized repo {bold(directory)}')
            continue
        jobs.append(exec_n(clone(github_url + gh, directory), semaphore))
    await asyncio.gather(*jobs)


async def cli_pull(args):
    _, repos = get_repos()
    os.chdir(whereami())

    total = len(repos)
    done = 0

    def finished(cmd, directory, exitcode):
        nonlocal done
        done += 1
        if exitcode == 128:
            eprint("Help: repo " + bold(directory) + " has "
            "local changes that have not been integrated with changes in "
            "the remote repository. You should integrate these changes "
            "manually with `" + bold('git merge') + "` or "
            "Altium if applicable.")
            eprint('')
        eprint(f"Completed {done}/{total}")

    semaphore = asyncio.Semaphore(MAX_JOBS)
    jobs = []
    for (_, directory) in repos:
        # Don't mess with repos that haven't been cloned yet
        if not Path(directory).exists():
            eprint(f'Warning: {bold(directory)} is not cloned yet. '
                    'Run `./repo.py init` to fix this.')
            finished('', '', 0)
            continue
        jobs.append(exec_n(gitcmd(['pull', '--quiet', '--ff-only'],
                                  cb=finished, chdir=directory),
                           semaphore))
    await asyncio.gather(*jobs)


class Colours:
    RESET  = '\x1b[0m'
    BOLD = '\x1b[1m'
    RED = '\x1b[31m'
    GREEN = '\x1b[32m'
    PURPLE = '\x1b[35m'
    YELLOW = '\x1b[33m'


STATUS_COLOURS = {
    RepoStatus.UNKNOWN:      Colours.RED,
    RepoStatus.UP_TO_DATE:   Colours.GREEN,
    RepoStatus.LOCAL_AHEAD:  Colours.PURPLE,
    RepoStatus.REMOTE_AHEAD: Colours.YELLOW,
}

STATUS_NAMES = {
    RepoStatus.UNKNOWN:      'unknown   ',
    RepoStatus.UP_TO_DATE:   'up to date',
    RepoStatus.LOCAL_AHEAD:  'needs push',
    RepoStatus.REMOTE_AHEAD: 'needs pull',
}


def colour(colour, text):
    """
    Print `text` with `colour`.
    """
    return colour + (text or '') + Colours.RESET


def bold(text):
    """
    Print `text` in bold.
    """
    return colour(Colours.BOLD, text)


async def cli_status(args):
    _, repos = get_repos()
    os.chdir(whereami())

    jobs = []
    for (_, directory) in repos:
        if not Path(directory).exists():
            eprint(f"Warning: repo {bold(directory)} is missing, run "
                   f"`{bold('./repo.py init')}` to fix this condition")
            continue
        jobs.append(get_status(directory))

    statuses = await asyncio.gather(*jobs)
    for (repo, status) in sorted(statuses, key=lambda e: e[0]):
        print(colour(STATUS_COLOURS[status], STATUS_NAMES[status]), '\t',
                repo, sep='')


async def cli_forall(args):
    _, repos = get_repos()

    total = len(repos)
    os.chdir(whereami())
    done = 0

    def finished(*_):
        nonlocal done
        done += 1
        eprint(f"Completed {done}/{total}")

    tasks = []
    for (_, directory) in repos:
        tasks.append(run_cmd(args.run[0], args.run[1:], chdir=directory,
                             cb=finished))
    await asyncio.gather(*tasks)


def main():
    async def fail(*args):
        raise ValueError('Subcommand not specified')

    ap = argparse.ArgumentParser()
    ap.set_defaults(cmd=fail)
    sps = ap.add_subparsers()

    init_parser = sps.add_parser('init')
    init_parser.set_defaults(cmd=cli_init)
    init_parser.add_argument('--https', action='store_true',
            help='Clone repos with https rather than ssh')

    pull_parser = sps.add_parser('pull')
    pull_parser.set_defaults(cmd=cli_pull)

    status_parser = sps.add_parser('status')
    status_parser.set_defaults(cmd=cli_status)

    forall_parser = sps.add_parser('forall')
    forall_parser.set_defaults(cmd=cli_forall)
    forall_parser.add_argument('run', nargs='+', help='Command to run')

    args = ap.parse_args()
    asyncio.run(args.cmd(args))


if __name__ == '__main__':
    main()
