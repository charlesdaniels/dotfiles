###############
Taskfile Schema
###############

.. contents::

Schema
======

A ``taskutil`` taskfile is a JSON file containing a dictionary with the
following keys:

* ``provides`` - a string containing the name of the task, for example
  ``"provides": "install-someprogram"``. This is the canonical name by which
  ``taskutil`` refers to this task. Must be unique across all tasks.

* ``manifest`` - a list of strings specifying files which are part of the task.
  This is is used to specify files relative to the tasks' top-level directory
  which should **not** be deleted when a clean operation is run. Note that the
  strings in this list *may* include glob patterns compatible with Python's
  ``pathlib.Path.glob``. Example: ``"manifest": ["foo.txt", "bar/*"]``

The following keys may also be included, but are not required:

* ``require-task``: a list of task names which must execute before this one.
  Example: ``"require-task": ["somtask", "anothertask"]``

* ``require-any``: a list of lists. Each inner list must succeed before the task
  can run. For an inner list to succeed, *any* of the task names specified
  within it must succeed. Example: ``[["task1", "task2"], ["task3", "task4"]]``

* ``run-script``: a list of commands which should be run. Each command is
  specified as a list of parts. For example to run the commands ``ls -l -a``
  and ``cat foo.txt`` in that order, you would specify ``"run-script": [["ls",
  "-l", "-a"], ["cat", "foo.txt"]]``. This style is used to avoid potential
  problems with string escaping. Note that each string in each sub-list support
  env formatting.

* ``require-uname``: a string specifying a regular expression, which the output
  of the command ``Uname`` must match. Example: ``"require-uname":
  ".*Linux.*"``.

* ``copy-file``: a list of source-destination pairs. If the destination exists,
  it will be overwritten silently. The source file should be specified relative
  to the task's root directory. Example: ``"copy-file": [["src/file",
  "/path/to/dest"]]``. The source and destination fields of each sub list
  support formatting env formatting.

* ``mark-executable``: a list of files which should be marked as executable.
  Example: ``"mark-executable": ["foo", "bar"]``. The file list supports
  env formatting.

* ``require-git``: a list of lists, each of which specifies a git repository
  which must be cloned before the task can be run. Each inner list contains the
  URL, the directory relative to the tasks' top level directory, and the branch
  to be checked out in that order. Example: ``"require-git":
  [["https://github.com/charlesdaniels/dotfiles", "dotfiles", "master"]]``.

* ``require-github``: as with ``require-git``, but the URL can be specified as
  a GitHub ``username/reponame`` string. Example: ``"require-github":
  [["charlesdaniels/dotfiles", "dotfiles", "masteR"]]``. Note that this implies
  that the ``https`` protocol will be used to download the repository.

* ``require-http``: a list of lists, each specifying a URL and a destination
  file. Each URL will be downloaded to the specified destination file using
  ``urllib``. Example: ``"require-http": [["http://foo.com/bar", "bar"]]``.
  The destination field of each sub-list supports env formatting.

* ``require-sudo``: a boolean. If true, it indicates that this task will
  require sudo access, and cause the ``$TASKUTIL_SUDO_PASSWORD`` environment
  variable to be populated. Example: ``"require-sudo": true``. If omitted, it
  is implied to be false.

* ``require-file``: asserts that a particular file(s) must exist before the
  task can be run. Example: ``"require-file": ["/path/to/file1",
  "/path/to/file2"]``.

* ``overlay``: Overlay one directory over top of the other. This implies that
  the destination directory is kept as is, and the source is copied into it.
  Any conflicts always keep the version from the source directory. Example:
  ``"overlay": [["src1/", "dest1/"], ["src2", "dest2"]]``. The destination 
  field of each sub-list supports env formatting.

Env Formatting
==============

Fields which support env formatting may use python-style formatting (``{key}``)
to substitute in values of interest to paths, commands, and so on. Fields which
support this are noted in the list above. The following keys can be used with
env formatting:

* ``HOME`` - the home directory of the user running taskutil.

* ``BIN_DIR`` - ``~/bin`` of the use running taskutil.

* ``TASK_DIR`` - the top-level directory of the task currently running. Note
  however that the current working directory of taskutil will be set to the 
  task directory before any commands are executed.

* ``SUDO_PASSWORD`` - the password required to obtain root access via ``sudo``.
  This variable is only populated when the ``require-sudo`` flag is set to
  true.

Note that when running commands via ``run-script``, all of the above values are
made available via environment variables prefixed with the string ``TASKUTIL``.
For example ``$TASKUTIL_HOME``.

Suggested Method for Running Commands as Root
=============================================

When writing system-level provisioning scripts, it often happens that commands
must be executed as root. The suggested approach is by using the command::

    ["sh", "-c", "echo $TASKUTIL_SUDO_PASSWORD | sudo -S THECMD"]

Replacing ``THECMD`` with the command to run.

Order of Execution
==================

Actions specified in a given task are executed in the following order:

* ``require-uname``
* ``require-file``
* ``require-github``
* ``require-git``
* ``require-http``
* ``overlay``
* ``copy-file``
* ``mark-executable``
* ``run-script``

