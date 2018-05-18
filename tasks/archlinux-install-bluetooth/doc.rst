Overview
========

Install and enable Bluetooth support for Archlinux. Note that this attempts to
apply the workaround ``pacmd set-card-profile 2 a2dp_sink`` as specified in
`this forum thread`_.

.. note::

    This approach is known to work correctly on the Thinkpad X220 with a
    ``AR9462`` wifi/bluetooth combo card installed. Some tweaking may be
    required for other hardware (?).

.. note::

    You may need to restart PulseAudio before Bluetooth audio devices can
    be successfully used. 

.. _`this forum thread`: https://bbs.archlinux.org/viewtopic.php?id=226325
