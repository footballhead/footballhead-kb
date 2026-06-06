No Man's Sky with HDR on Linux
==============================

I recently paved my Windows install for Ubuntu 26.04. I also recently got a nice HDR television. However, when I run No Man's Sky and open the graphics settings, I noticed that the HDR option was missing. Turns out that No Man's Sky uses Proton which might be part of the problem.

What worked for me: GE-Proton
-----------------------------

I used `GE-Proton`_ with these launch options:

.. code:: shell 

    PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 %command%

I downloaded it with `ProtonPlus`_ from `Flathub`_

What didn't work: Gamescope
---------------------------

I tried Gamescope but to no avail. Here's the command soup I tried based on `this Reddit thread <https://www.reddit.com/r/linux_gaming/comments/1ms8p8t/enabling_no_mans_sky_hdr/>`_:

.. code:: shell

    DXVK_HDR=1 gamescope --hdr-enabled --expose-wayland -w 3840 -h 2160 -W 3840 -H 2160 -f -r 60 --hdr-debug-force-support -- %command%

.. _ProtonPlus: https://github.com/Vysp3r/ProtonPlus
.. _Flathub: https://flathub.org/en/apps/com.vysp3r.ProtonPlus
.. _Flatpak: https://flathub.org/en/setup/Ubuntu
.. _GE-Proton: https://github.com/GloriousEggroll/proton-ge-custom
