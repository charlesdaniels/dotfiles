###############################
The Dotfiles of Charles Daniels
###############################

.. image:: https://readthedocs.org/projects/charlesdaniels-dotfiles/badge/?version=latest
:target: http://charlesdaniels-dotfiles.readthedocs.io/en/latest/?badge=latest
:alt: Documentation Status


.. contents::

What is This?
=============

This project consists of a tool (``taskutil``) for executing a DAG (directed
acyclic graph) of tasks such that each task is not executed until each of it's
dependencies are executed. ``taskutil`` is used to implement a desired-state
configuration system which allows my dotfiles, any part of my dotfiles, as well
as my preferred environment for various UNIX variants to be provisioned in an
auditable and unattended fashion.

How Does it Work?
=================

The directory ``tasks/`` contains one folder per task. Each task must, at a
minimum contain a taskfile, located at ``tasks/taskname/task.json``. This file
specifies the dependencies of the task (such as other tasks which must be
executed first, or resources which must be fetched from the network), as well
as the actions which must be taken to complete the task itself.

A useful set of actions is exposed via the taskfile schema, with which many
basic software installation and configuration operations can be performed.
Where more power is required, a task can call out via arbitrary shell commands.

Facilities are also in place to pass useful environment variables into commands
which are to be executed, such as the user's home directory, and the top-level
directory of the task being executed.

Sudo authentication is accomplished by, if a task indicates that root access
will be required, prompting the user for their password and storing it in
memory. The password is then passed into tasks via an environment variable.
This is only done for tasks which indicate that they require sudo access.
``taskutil`` does not itself log this password anywhere on disk, but the code
executed by a task should always be audited to ensure it does not log
``$(env)`` to disk.

Taskutil explicitly does **not** solve the versioning problem, nor does it have
any equivalent of repositories or channels. A given copy of ``taskutil`` is
associated with exactly one ``tasks/`` directory, which has a single canonical
master state at any given time.

Can I use It?
=============

Go for it!

Feel free to use ``taskutil`` on it's own (as part of your own configuration
management system), any or all of the tasks from ``tasks/`` or any combination
of the two.

If you mean "can I use your dotfiles": sure, just run ``./taskutil -p -r
install-user-config``. This will install all of my dotfile, user configuration,
XDG MIME associations, and so on. Be warned **this will silently delete any
files which already exist**. You can also provision various UNIX systems
according to my personal preferences by running the appropriate task, which are
usually named like ``provision-VARIANT-SET``, where ``VARIANT`` would be the
variant of UNIX to be provisioned (i.e. ``archlinux``, or ``darwin``), and
``SET`` would be a string like ``core`` or ``workstations``. Refer to the
relevant task documentation for more details.

Is it Portable?
===============

``taskutil`` itself is implemented in pure Python 3. It should run on any
platform which supports Python 3 and it's full standard library. You also need
to have ``git`` in ``$PATH``. Individual tasks will usually make more
restrictive assumptions. For those wondering, ``taskutil`` itself should work
on Windows, but few if any of the tasks in this repository will.



