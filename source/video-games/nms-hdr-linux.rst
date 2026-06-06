No Man's Sky with HDR on Linux
==============================

I managed to get HDR with Steam Input "working" on Linux for No Man's Sky by launching Steam Big Picture in Gamescope:

.. code:: shell

    gamescope --hdr-enabled --steam -- steam -tenfoot

However, it's very buggy still.

Motivation
----------

I recently paved my Windows install for Ubuntu 26.04. Then I bought got a nice HDR television. However, if I just open Steam and run No Man's Sky, the HDR setting is missing.

There's two main issues:

1.  HDR support is limited to a handful of solutions.
2.  Since No Man's Sky doesn't have native controller support and relies on Steam Input, I need Steam integration to work.

Setup
-----

Software:

-   Ubuntu 26.04, with KDE installed afterwards
-   Running KDE with Wayland

::

    $ gamescope --version
    [gamescope] [Info]  console: gamescope version 3.16.20+ds-1 (gcc 15.2.0)

    $ nvidia-smi
    Sat Jun  6 16:16:44 2026       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 595.71.05              Driver Version: 595.71.05      CUDA Version: 13.2     |
    +-----------------------------------------+------------------------+----------------------+

Hardware:

-   NVIDIA GeForce RTX 4070 Ti
-   PS5 controller
-   TP-Link UB500 USB Bluetooth dongle

What "worked" for me: Gamescope
-------------------------------

I installed gamescope from the ``apt`` repository:

.. code:: shell

    sudo apt install gamescope

Gamescope works but in a `very specific` way: I `need` to launch with Steam integration in Big Picture mode. Then, launching No Man's Sky through the Big Picture UI makes both Steam integration and HDR work.

.. code:: shell

    gamescope --hdr-enabled --steam -- steam -tenfoot

I can dress up this command with my particular settings:

.. code:: shell

    gamescope --hdr-enabled --steam  -w 3840 -h 2160 -f -r 120 -- %command%

Confusingly, if I only launch with Steam integration then I get this "phantom" window that appears on the task bar but I can never focus. I can't figure out why, nor do I know what Big Picture seems to be immune to this issue.

However, there are still some bugs:

-   The screen sometimes goes black and I need to restart my desktop session
-   NMS will randomly crash

Things that I've tried:

-   Turning off autosleep, display dimming, etc... Anything that would turn off the displays.

What didn't work: GE-Proton
---------------------------

GE-Proton was a lot of work for a dead end.

I spent a lot of time installing Flatpak to install ProtonPlus to install GE-Proton only to hit a known issue: you can't have both Steam integartion and HDR. This is a deal breaker for me.

This launch configuration works for HDR but the Steam integaration is broken:

.. code:: shell 

    PROTON_USE_SDL=1 PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 %command%

Any other configuration doesn't have HDR support.

Aside: Graphics Settings
------------------------

I can't run 4K at 120FPS with Ultra settings:

- At 4K with Ultra settings I get ~60 FPS
- Ar 4k with 50% resolution scale and Ultra settings gets me to ~90 FPS
