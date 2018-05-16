############################################
Understanding ``taskutil`` Dependancy Graphs
############################################

Throughout this documentation, you may notice dependency graphs, such as the
one listed in the "Overview of Tasks" section of the index page.

Each node in these graphs represents one task. If the node for a task is
colored red, it requires sudo access to run. If the node is colored orange, the
corresponding task does not require sudo access, but it depends on other tasks
which do.

Arrows between nodes represent dependencies. An arrow pointing *from* task A
*to* task B indicates that task B must execute before task A can execute.  An
arrow with a dashed line indicates that the dependency is part of a
``require-any`` group.

.. todo::

   Should switch to differentiating sudo requirements by node edge style
   or shape rather than color. This is both to improve readability by color
   blind individuals, and also to produce more useful output when printed on a
   black and white printer.
