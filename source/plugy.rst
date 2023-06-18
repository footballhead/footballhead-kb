=====
PlugY
=====

Website: http://plugy.free.fr/en/index.html

PlugY is a mod for Diablo 2 Lord of Destruction by Yohann Nicolas that adds quality of life additions to single-player:

* Infinite shared stash
* Ladder runeworks
* Ubers

------------
Distribution
------------

Nicolas publishes four main artifacts:

#. ``PlugY_The_Survival_Kit_${VERSION}.ZIP``: Archive of ``PlugY.dll``, ``PlugY.exe``, and associated graphics/config files
#. ``PlugY_The_Survival_Kit_${VERSION}_D2FilePatcher.ZIP``: Archive of ``RestoreD2File.exe`` and ``PatchD2File.exe``
#. ``PlugY_The_Survival_Kit_${VERSION}_Installer.exe``: NSIS installer wizard, packages all the above
#. ``PlugY_The_Survival_Kit_${VERSION}_source_code.ZIP``: Source for all of the above

------
Source
------

Nicolas released the source for v14.03. I'm interested in how it alters the game's behavior for personal modding projects (like Pre-ablo).

Basics
======

PlugY is written in C++03 and compiles with Visual C++ 2008 Express Edition.

Visual C++ 2008 Express Edition
===============================

`This StackOverflow article <https://stackoverflow.com/questions/15318560/visual-c-2008-express-download-link-dead>`_ has links to Visual C++ 2008 Express Edition. I'll reproduce them here:

* Just VS 2008 Express: https://download.microsoft.com/download/8/B/5/8B5804AD-4990-40D0-A6AA-CE894CBBB3DC/VS2008ExpressENUX1397868.iso
* VS 2008 Express SP1: https://download.microsoft.com/download/E/8/E/E8EEB394-7F42-4963-A2D8-29559B738298/VS2008ExpressWithSP1ENUX1504728.iso

I installed SP1 into a Windows XP VM.

Layout
======

* ``Commons``: Reused headers and source across the code
* ``PlugY``: Source for ``PlugY.dll`` (the bulk of the code)
* ``PlugYInstall``: Source for ``RestoreD2File.exe`` and ``PatchD2File.exe``
* ``PlugYInstaller``: Files for making ``PlugY_The_Survival_Kit_${VERSION}_Installer.exe``
* ``PlugYRun``: Files for PlugY.exe

.sln Layout
===========

All ``.sln`` files follow a similar filter layout. The author is French so the filter names are in French. Roughly translated:

* ``Fichiers d'en-tete``: header files ``*.h``
* ``Fichiers de ressources``: resource files ``*.rc``
* ``Fichiers sources``: source files, ``*.cpp``

Elements of ``Commons`` are included as sub-filters of the above as needed.

PlugY Folder
============

TODO

PlugYInstall Folder
===================

Source for ``RestoreD2File.exe`` and ``PatchD2File.exe``. These programs modify ``Game.exe`` or ``D2gfx.dll`` (depending on the version) to load ``PlugY.dll`` without having to run ``PlugY.exe``

Which binary is built depends on the configuration:

* ``Release``: This produces ``PlugYInstall.exe`` but is actually ``PatchD2File.exe``
* ``Restore``: This produces ``PlugYInstall.exe`` but is actually ``RestoreD2File.exe``

This is accomplished by setting the ``RESTORE`` macro, which controls code in ``main()``.

Oddities:

* ``RestoreD2File.exe`` has a runtime check for command-line arguments. If ``-u`` is present then it switches into the uninstall mode. Technically this means ``RestoreD2File.exe`` is redundant...

PlugYInstaller Folder
=====================

Nullsoft Scriptable Install. All binaries must be copied into here.

Some oddities:

* ``PatchD2gfxDll.exe`` and ``RestoreD2gfxDll.exe`` are here as prebuilts (built for 14.03!) but I can't find an easy way to generate them nor are these present in the official installer. There is a runtime check in ``RestoreD2File.exe`` to determine if ``Game.exe`` or ``D2gfx.dll`` should be patched; theoretically this could be manually changed into a compile-time check for... reasons? Maybe it's just a hold-over from old versions.

Making a Release
================

Open Visual Studio 2008 Command Prompt::

    msbuild PlugY/PlugY.sln /p:Configuration=Release
    cp PlugY/Release/PlugY.dll PlugYInstaller/PlugY.dll

    msbuild PlugYInstall/PlugYInstall.sln /p:Configuration=Release
    cp PlugYInstall/Release/PlugYInstall.exe PlugYInstaller/PatchD2File.dll

    msbuild PlugYInstall/PlugYInstall.sln /p:Configuration=Restore
    cp PlugYInstall/Restore/PlugYInstall.exe PlugYInstaller/RestoreD2File.dll

    msbuild PlugYRun/PlugRun.sln /p:Configuration=Release
    cp PlugYRun/Release/PlugYRun.exe PlugYInstaller/PlugY.exe

    # TODO: Generate installer from NSI
