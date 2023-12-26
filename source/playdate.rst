========
Playdate
========

A modern hand-held for retro-inspired games. With a crank!

---
SDK
---

There's two flavors:

#. Lua. Seems like they expect you to use this one. It provides more goodies and a cleaner workflow.
#. C. Technically more performant than Lua but more DIY... And you need to know C.

I would highly recommend reading the Lua SDK reference (even if you only plan on using C) since important details like using ``pdc`` are only mentioned there.

--------
Workflow
--------

#. Put all assets (except C code) into ``Source/`` dir. This includes fonts, sounds, images, and Lua code. Technically, you can name this whatever you want... except the makefile support in the SDK assumes that this is the name for that folder
#. Put C source wherever. Use either Make or CMake to compile.
#. Run ``pdc Source myproject.pdx`` to assemble the final app
#. Use the simulator to sideload the code onto a Playdate

``Source/pdxinfo`` is your metadata file.

-----
C SDK
-----

- Download: https://play.date/dev/
- Reference: https://sdk.play.date/2.0.3/Inside%20Playdate%20with%20C.html

I wrote a docker file since this can be annoying to get working on Windows. Unfortunately, this won't build for the simulator. Also, this assumes that you're using Makefiles:

.. code-block:: docker

    # TODO could use multi-phase builder so that wget is not in the final image
    FROM ubuntu:latest

    # Install toolchain. libpng16-16 is required for pdc
    RUN apt-get update \
        && apt-get install -y \
            gcc-arm-none-eabi \
            wget \
            make \
            libpng16-16 \
        && rm -rf /var/lib/apt/lists/*

    # Grab SDK
    RUN wget https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-2.0.3.tar.gz \
        && tar xf PlaydateSDK-2.0.3.tar.gz \
        && rm -rf /PlaydateSDK-2.0.3.tar.gz

    # Export toolchain path
    ENV PLAYDATE_SDK_PATH=/PlaydateSDK-2.0.3

    # TODO add PLAYDATE_SDK_PATH/bin to PATH

Assuming you use the Makefile approach, use the docker image with a volume mount:

.. code-block:: bash

    # Build the docker container (assuming it's in cwd as Dockerfile)
    docker build -t playdate-sdk .

    # Run the docker container with a volume mount
    docker run -v ${PWD}:/code -ti playdate-sdk bash

    # CD into mounted code
    cd /code

    # Run make. `device` uses gcc to cross compile. If you just `make` (no args) then it tries to build for the Linux simulator and will complain that gcc is not installed.
    make device

    # The Makefile will put the built pdex.elf into Source. PDC will pack that along with pdxinfo and assets 
    pdc Source myproduct.pdx

Here's a minimal makefile:

.. code-block:: make

    # common.mk doesn't look at PLAYDATE_SDK_PATH for some reason, it wants SDK
    SDK=$(PLAYDATE_SDK_PATH)

    # C source to compile
    SRC=main.c

    # Defines targets for using the cross compile toolchain and for putting binary artifacts into the right place
    include $(SDK)/C_API/buildsupport/common.mk

Suggested project layout::

    project/
        Source/         <-- For pdxinfo (metadata) and other assets. Also, the Makefile will put stuff here.
            pdxinfo     <-- Metadata
            image.png   <-- Graphical assets also go into the Source folder
            sound.wav   <-- Audio assets also go into the Source folder
        main.c          <-- Program source. Can be split over multiple files
        Makefile        <-- Makefile which uses the buildsupport SDK script
        Dockerfile      <-- The dockerfile described in this doc

Suggested .gitignore::

    # Ignore the generated build/ directory
    build/

    # Ignore generated files outside the build dir
    # This includes Source/pdex.elf (cross-compiled), pdex.so (sim)
    pdex.*

    # Ignore the packaged app
    *.pdx

---------------
How to sideload
---------------

You need to use the simulator to sideload custom apps onto the Playdate. While you can docker-ize the build environment, you'll still need the simulator on the host. Unfortunately this resists automation... 