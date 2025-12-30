Building (as much as possible) from source
==========================================

Building from source is good because the developer doesn't need to perform a lot of setup, you can establish provenance, and you control which software is being used.

Bootstrapping is essentially the process of making something our of nothing.

Bootstrapping problems:

- self-hosting programs. E.g. need CMake to build CMake
- precompiled programs are need to some level, e.g the compiler (especially MSVC). The goal is to minimize "trust" by 

CMake
=====

On Windows, need a posix shell to bootstrap. CMake suggests mingw/MSYS2

MSYS2
=====

The `website <https://www.msys2.org/>`_ says to download the installer. This is the repo: https://github.com/msys2/msys2-installer . make-msys2-installer assumes that you're alredy running msys. It creates a chroot using pacman and installs some packages. Then it uses binarycreator from qt installer.

Msys2 is built on top of cygwin

cygwin
======

https://cygwin.com/

Visual Studio
=============

Using x64 native tools for command prompt - how to automate

- ``%comspec% /k "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"``
- ``C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build``
- ``@call "%~dp0vcvarsall.bat" x64 %*``
- ``call "%~dp0..\..\..\Common7\Tools\vsdevcmd.bat" %__VCVARSALL_VSDEVCMD_ARGS%``
- ``C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools``
- 