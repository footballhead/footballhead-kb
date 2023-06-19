========
Diablo 2
========

Notes for getting Diablo 2 running, etc. I have ISOs backups of the CDs.

-------------
General Notes
-------------

* You can install off ISOs
* You can't play without the retail CD before PATCH 1.13c (Unless you use Alcohol 52%). ISOs won't work, nor will burned discs.
* With 1.13c you can use EXPANSION.ISO to run LoD
* Or with 1.13c you can copy every MPQ from EXPANSION.ISO to the LoD folder

-----------------------------
New Installation (Windows 10)
-----------------------------

Windows 8+ provides the ability to mount ISOs by double-clicking them.

Installing DII
==============

#. Turn your volume down. Trust me.
#. Mount ``INSTALL.ISO`` (the Install disc)
#. Run ``SETUP.EXE`` on the disc
#. Run the full installation. Use your Diablo II serial (name doesn't matter).

Whenever you need to switch discs (to ensure it reuses the same drive letter):

#. Eject the current disc by right-clicking the drive and choosing Eject
#. Mount the required disc image

Installing LoD
==============

#. Unmount all discs
#. Mount ``EXPANSION.ISO`` (the expansion disc)
#. Run ``SETUP.EXE`` on the disc
#. Upgrade the installation, using your Expansion serial.
#. After normal install: upgrade from multi-player to full installation.

Use the same tricks for swapping discs.

Using Glide3D wrapper
=====================

Diablo II supports Glide3D (found on old gfx cards). Sven Labusch made a Glide3D wrapper that works well on modern Windows but requires extra steps.

#. Download the latest zip and extract: https://www.svenswrapper.de/english/text/downloads.html
#. Copy ``glide3dx.dll`` to the Diablo install directory (e.g. ``C:\Program Files (x86)\Diablo II``)
#. Run ``D2VidTst.exe``. If a dialog does not immediately show then you'll need to set the compatability mode to WinXP. You'll need to click Run Test. It will iterate through video modes (messing with your screen in the process).	Select Glide3D at the end.

.. note:: ``D2VidTst.exe`` is not in patch 1.14+ so you'll need to launch the game with ``-3dfx``

Install required patch
======================

For mods, you'll probably need 1.13c!

Patches can still be downloaded from Blizzards FTP:

* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_114d.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_114c.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_114b.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_114a.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_113d.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_113c.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_113.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_112a.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_111b.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_111.exe
* http://ftp.blizzard.com/pub/diablo2exp/patches/PC/LODPatch_110.exe

Other sources:

* https://archive.org/details/diablo2patches
* https://web.archive.org/web/*/http://ftp.blizzard.com/pub/diablo2exp/patches/PC/*

------------------------------
Running without the CD (Legal)
------------------------------

.. note:: You MUST be running patch 1.13c or higher!

Copy ``D2XMUSIC.MPQ`` from ``EXPANSION.ISO`` (the Expansion disc) to the game install directory (e.g. ``C:\Program Files (x86)\Diablo II``).

-----------------------------------------
Running without the CD (Alcohol 52%/120%)
-----------------------------------------

.. note:: I can only get this working on Windows XP

Since the Diablo II discs use SecuROM, you need a virtual drive capable of RMPS emulation. Alcohol software is capable and free. To use:

#. Install
#. Set up a virtual drive
#. Change the Diablo II registry key that stores the CD drive (open regedit, search Diablo)
#. Open properties, Extra Emulation, turn on "Sub-Data Channel Fixed and Emulation"

---------------------------------------------
Downgrading LoD Patches (e.g. 1.13d to 1.13c)
---------------------------------------------

Running certain mods might require downgrading:

* unzip game-lod.zip (TODO: link) and copy game.exe to the LoD folder (replace the game.exe there)
* run the ``LODPatch_*.exe`` again and it should work

---------------
Installing D2SE
---------------

D2SE is a mod manager. The installer is straight-forward. However, make sure ``D2SE.exe`` launches in Win7 compatability mode.

-----
PlugY
-----

TODO

------------
D2SE + PlugY
------------

Use PlugY-10.00-D2SE.zip (TODO add link). Unzip to ``C:\Program Files (x86)\Diablo II\PlugY``.

Notes:

* You need Plugy 10.00. Nothing else will work.
* Get the ZIP version. Extract to ``C:\Program Files (x86)\Diablo II\PlugY``
* Copy ``C:\Program Files (x86)\Diablo II\PlugY\PlugY`` (``.dc6`` files, etc) into ``C:\Program Files (x86)\Diablo II\PlugY``

-------------------------------------
Other Multiplayer on Fresh Windows XP
-------------------------------------

If I'm running 1.0 I tend to prefer Windows XP installed on physical hardware. Sometimes I don't have a NIC driver installed, so I don't have an IP address, so I can't run Other Multiplayer.

Install a loopback device

TODO add instructions here

---------------
Troubleshooting
---------------

UNHANDLED_EXCEPTION on startup
==============================

Caused by a bad video mode selected in ``vidtest``. Try rerunning and selecting Direct2D. Alternatively, run in windowed mode (add ``-w`` to shortcut)