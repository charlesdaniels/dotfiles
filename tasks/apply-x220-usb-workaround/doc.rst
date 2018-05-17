Overview
========

The ThinkPad X220 with the i7 has a problem with the USB 3.0 controller which
causes it to fail after resuming from sleep. This does not affect the USB 2.0
controller. The fix is to reset the kernel's XHCI subsystem, which is
accomplished via the ``system-reset-xhci`` script installed via
``install-scripts-opt``. Note that this fix is Linux specific. 

This task specifically creates a systemd unit which runs after suspend (i.e.
the laptop has just resumed from sleep). To that end, this particular
implementation of this fix is *also* systemd specific.
