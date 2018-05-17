Overview
========

This task installs a systemd service which causes ``system-lock`` to be run
from ``/opt`` (as provided by ``install-scripts-opt``) any time the laptop
sleeps. This is independant of ``xautolock``. Note that the service runs as
root, and ``system-lock`` will attempt to intelligently infer what user account
it should run as using ``su``.
