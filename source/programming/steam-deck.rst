Programming on a Steam Deck
===========================

-   SteamDeck runs ArchLinux, so you can use ``pacman``.
-   However, the use of A/B software updates means that the OS image is read-only by default and modifications are wiped by software upates. You can get around this with ``steamos-devmode``.
-   Additionally, Valve trimmed all unnecessary files from the OS parition.  You can get around this with ``steamos-unminimize``.

.. note:: ``steamos-devmode`` and ``steamos-unminimize`` are from the ``steamos-customizations-jupiter`` package. The source is here: https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/jupiter-3.7/steamos-customizations-jupiter-3.7.20251010.1-1.src.tar.gz

Approaches
----------

#.  Run ``steamos-devmode`` and ``steamos-unminimize`` and use ``pacman``. Reinstall things when a software update happens; script the process to make it easier.
#.  Use a container. This still typically requires installing stuff from ``pacman``
#.  Use Homebrew for Linux. This installs things in ``/home/linuxbrew/.linuxbrew`` so they persist across software updates. However, packages like GCC require GCC to already be installed, which defeats the purpose.
#.  Use ``pacman -r`` to install packages to an alternate location like ``/home/deck/.root``. The only wrinkle is the LD_LIBRARY_PATH is used to find the libs and you need to make an alias for pacman to specify the root and keyring.

The last option is basically `pacstrap`_. Someone wrote a pared-down version for Steam Deck: https://www.jeromeswannack.com/projects/2024/11/29/steamdeck-userspace-pacman.html. Note that I had to modify this to remove the following::

    # Import and sign SteamOS keys
    log "Importing SteamOS keys..."
    sudo pacman-key --gpgdir "$GPG_DIR" --add /etc/pacman.d/gnupg/pubring.gpg
    sudo pacman-key --gpgdir "$GPG_DIR" --lsign-key "GitLab CI Package Builder <ci-package-builder-1@steamos.cloud>"

Also, instead of writing to ``.bashrc`` (which I've seen discouraged), I wrote it to a script that I just source in my shell::

    export USERROOT="$HOME/.root"
    export PATH="$PATH:$USERROOT/usr/bin"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$USERROOT/lib:$USERROOT/lib64"
    export PERL5LIB="$USERROOT/usr/share/perl5/vendor_perl:$USERROOT/usr/lib/perl5/5.38/vendor_perl:$USERROOT/usr/share/perl5/core_perl:$USERROOT/usr/lib/perl5/5.38/core_perl"
    alias pacman_='sudo pacman -r $USERROOT --config $USERROOT/etc/pacman.conf --gpgdir $USERROOT/etc/pacman.d/gnupg --dbpath $USERROOT/var/lib/pacman --cachedir $USERROOT/var/cache/pacman/pkg'

Now things work::

    pacman -Sy
    pacman -S gcc
    g++ --sysroot $USERROOT test.cc

.. _pacstrap: https://gitlab.archlinux.org/archlinux/arch-install-scripts/-/blob/master/pacstrap.in?ref_type=heads