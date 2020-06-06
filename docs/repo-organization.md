# Organization of the Electrical repositories

We store our PCB designs in separate repositories per-design, using a git
submodule to reference the version of the shared Altium libraries in use. This
provides a couple of benefits: old designs will still build since they are
linked to the version they use, and git tags can be used to mark revisions that
were sent to fab.

`repo.py` is a tool that manages clones of all the repositories and installs a
hook that ensures the libraries are up to date before pushing. It also allows
maintainers to quickly ensure they have the latest version of all the projects
while reviewing.

# repo.py

## Usage

### `./repo.py init [--https]`

Clone all the tracked repositories. Use `--https` to clone with the https
protocol rather than using ssh.

### `./repo.py pull`

Runs a pull on all of the repositories to grab the latest version. This does
not perform merges. This only performs fast-forwards. If there is both new
content locally and remotely, pull will fail on the repository where this is
the case and you should pull or fetch+merge manually.

### `./repo.py forall <cmd>`

Runs the given shell command in each repository in parallel.

### `./repo.py status`

Checks whether all of the repos here are up to date: fetches and checks the
status of the master branch.

## Configuration

`repo.py` reads a list of repositories line-by-line from `repos.txt` relative
to where it is installed. Each line is `<GitHub-User/Repo> <Local Name>`.

It supports directives of the format `!DIRECTIVE_NAME VALUE`. Currently, the
only directive supported is `!check_submodule SUBMODULE-NAME`, which enables
the installation of the hook that checks that `SUBMODULE-NAME` (if present)
under each repository is up to date before allowing push.
