# Organization of the Electrical repositories

We store our PCB designs in separate repositories per-design, using a git
submodule to reference the version of the shared Altium libraries in use. This
provides a couple of benefits: old designs will still build since they are
linked to the version they use, and git tags can be used to mark revisions that
were sent to fab.

We use the `setup.sh` script in this repository to clone all the PCB projects
and add pre-push hooks to them that ensure that Altium libraries are up to date
and block push if they need to be updated.
