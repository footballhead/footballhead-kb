No Man's Sky with HDR on Linux
==============================

I recently paved my Windows install for Ubuntu 26.04. I also recently got a nice HDR television. However, when I run No Man's Sky and open the graphics settings, I noticed that the HDR option was missing. Turns out that No Man's Sky uses Proton which might be part of the problem.

There's two main issues:

1.  HDR support is limited to a handful of options
2.  Need Steam integration for Steam Input (controllers) to work. No Man's Sky doesn't have native controller support and relies on Steam Input

What worked for me: Gamescope
-----------------------------

I installed gamescope from apt:

.. code:: shell

    sudo apt install gamescope

Gamescope works but in a `very specific` way: I `need` to launch with Steam integration in Big Picture mode. Launching No Man's Sky through the Big Picture UI makes Steam integration and HDR work.

.. code:: shell

    gamescope --hdr-enabled --steam -- steam -tenfoot

I can dress up this command with my particular settings:

.. code:: shell

    gamescope --hdr-enabled --steam  -w 3840 -h 2160 -W 3840 -H 2160 -f -r 120 -- %command%

Confusingly, if I only launch with Steam integration then I get this "phantom" window that appears on the task bar but I can never focus. I can't figure out why, nor do I know what Big Picture seems to be immune to this issue.

What didn't work: GE-Proton
---------------------------

GE-Proton was a lot of work for a dead end.

 I spent a lot of time installing Flatpak to install ProtonPlus to install GE-Proton only to hit a known issue: you can't have both Steam integartion and HDR. This is a deal breaker for me.

This launch configuration works for HDR but the Steam integaration is broken

.. code:: shell 

    PROTON_USE_SDL=1 PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 %command%

Any other configuration doesn't have HDR support.
