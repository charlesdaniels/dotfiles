Overview
========

This script installs a subset of my scripts (see the ``install-scripts`` task)
which need to be executable by the root user account via a hard-coded path. In
general, this is useful for scripts which must be executed as part of services.
The scripts here are symlinked to those from the ``install-scripts`` task and
are thus exactly the same, except for installation location.
