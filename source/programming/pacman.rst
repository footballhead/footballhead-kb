pacman (ArchLinux)
==================

Config is in ``/etc/pacman.conf``. ``DBPath`` says where the package database is located (e.g. on Steam Deck it's ``/usr/lib/holo/pacmandb``).

``pacman -Q``
    List all installed packages

``pacman -Qi <PACKAGE>``
    Print package information


.. note:: ``pacman`` packages don't contain information about how to build the package or clone the source. ArchLinux wants you to use ``pkgctl repo clone`` but that hardcodes the ArchLinux GitLab host. Valve just happens to publish Steam Deck source here: https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/