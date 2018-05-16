#####################
Task Directory Format
#####################

Task directories **must** contain at least a *taskfile* named ``task.json``.

Task directories **may** contain a file named ``doc.rst``, which will be
appended to the automatically generated documentation page for that task when
this wiki is compiled. Note that this document should not contain a page title
or ``.. contents::`` directive, as these are generated automatically.

Task directories **may** contain any other arbitrary files or directories.

Note that any files or directories which are included in the task **must** be
listed in the ``manifest`` field of the taskfile, or they will be deleted
during cleaning. ``task.json`` and ``doc.rst`` do not ned to be included in the
manifest explicitly.
