gn
==

Meta-build system used by Chromium, Fuschia, pigweed. Stands for "generate ninja".

Build from https://gn.googlesource.com/gn/::

    git clone https://gn.googlesource.com/gn
    cd gn
    python build/gen.py
    ninja -C out

Reference: https://gn.googlesource.com/gn/+/main/docs/reference.md

Overview
--------

Similar to CMake. First, you generate::

    gn gen out

Then you build::

    ninja -C out

The generation phases parses the .gn and creates build.ninja files. This is where functions and variables are evaluated and expanded. Substitutions are turned into ninja variables.

The build phase uses build.ninja to actually invoke the compiler. This is when substitutions are expanded (via ninja variables)

Terminology
-----------

- dotfile: the ``.gn`` in your source root. Used by gn to find the build config
- build config: describes the toolchain
- toolchain: the linker, compiler, etc
- buildfile: ``BUILD.gn``, describes targets
- targets: how to turn inputs into outputs. gn is prescriptive about how, e.g. ``executable()`` uses the ``"cc"`` and ``"link"`` tools, etc.
- function
- label
- variable
- substitution: ``{{foo}}``, done when the command is executed. Expansion is differed until when ``ninja`` is run; ``gn`` can't access these values

Setting up Minimal configuration
--------------------------------

gn doesn't come with anything by default, you have to set it up yourself. (Though you can likely copy from fuschia or chromium)

You need:

- a build configuration which specifies the toolchain
- build rules for your target

Hierarchy::

    .gn
    build/
        BUILDCONFIG.gn
        toolchains/
            BUILD.gn
    BUILD.GN

//.gn
~~~~~

Create ``.gn`` file in source root. Define the ``buildconfig`` variable, which tells ``gn`` about your toolchain. Here's the typical file::

    # Look at the provided file for the default toolchain
    buildconfig = "//build/BUILDCONFIG.gn"

.. tip::

    Putting gn related files in ``//build`` is a common convention. Make sure this isn't in your ``.gitignore``!

    Typically, ``//out`` is used as the build directory. Make sure that is in your ``.gitignore`` ;)

//build/BUILDCONFIG.gn
~~~~~~~~~~~~~~~~~~~~~~

Call `set_default_toolchain`_::

    # buildconfig was a variable set to a path
    # set_default_toolchain is a function that takes a label
    # //build/toolchains is conventional
    set_default_toolchain("//build/toolchains:msvc")

.. _set_default_toolchain: https://gn.googlesource.com/gn/+/main/docs/reference.md#func_set_default_toolchain

//build/toolchains/BUILD.gn
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Convention place to store `toolchain`_::

    toolchain("msvc") {}

.. _toolchain: https://gn.googlesource.com/gn/+/main/docs/reference.md#func_toolchain

An empty toolchain will allow gn to run but the generated ninja files basically don't do anything.

//BUILD.gn
~~~~~~~~~~

To get gn to do anything you need a non-empty buildfile.

If you have a simple example, you can just put your targets in the root buildfile.

With a deep directory structure, typically you add things to the ``all`` or ``default`` group (what Ninja compiles if no target is given)::

    group("default") {
        # Add labels to deps
        deps = []
    }

The above is useful if you're bootstrapping a new dir since, despite there not being targets, it's enough to get gn to do something.

Further Setup
-------------

Now that you can ``gn gen out`` and ``ninja -C out``, we can start actually compiling stuff.

Hierarchy::

    .gn
    build/
        BUILDCONFIG.gn
        toolchains/
            BUILD.gn
    BUILD.gn
    main.c

//BUILD.gn
~~~~~~~~~~

Add a target::

    group("default") {
        deps = ["//c/hello-world"]
    }

//c/hello-world/BUILD.gn
~~~~~~~~~~~~~~~~~~~~~~~~

Add an executable::

    executable("hello-world") {
        sources = [
            "main.c"
        ]
    }

//c/hello-world/main.c
~~~~~~~~~~~~~~~~~~~~~~

Prints hello world::

    #include <stdio.h>

    int main(int argc, char** argv) {
        printf("Hello world\n");
        return 0;
    }

//build/toolchain/BUILD.gn
~~~~~~~~~~~~~~~~~~~~~~~~~~

A minimal working C toolchain for MSVC::

    toolchain("msvc") {
        # Linker for `executable`
        tool("link") {
            # The tool requires command to be defined
            # {{inputs}} is an expansion or substitution of all cc tool outputs
            command = "link {{inputs}} /out:{{target_output_name}}.exe"
            # Must be at least one output file
            outputs = ["{{target_output_name}}.exe"]
        }

        # gn won't complain if cc tool is missing. It does have odd behavior: will try to link without inputs...
        tool("cc") {
            # By default MSVC will make //out/{{source_name_part}}.obj. Need to tell it to put things specifically in the target out dir.
            command = "cl /c {{source}} /Fo:{{target_out_dir}}/"
            outputs = ["{{target_out_dir}}/{{source_name_part}}.obj"]
        }
    }

Default vs all target
---------------------

``ninja -C out`` invokes the ``default`` target. You can change the default target by defining a target called ``"default"``

``ninja -C out all`` invokes the ``all``. This is everything in your ``BUILD.gn`` and all of its dependencies.

Example::

    # The defalt target (`ninja -C out`). This makes it so that nothing happens by default
    group("default") {}

    # The `all` target includes `default` and `others`. This will cause `//foo` and `//bar` to be generated (and all its deps)
    group("others") {
        deps = ["//foo", "//bar"]
    }

    # If you have //baz/BUILD.gn, you can't build it since it's not listed here.

Generating gn from CMake
------------------------

NOTE: This will be config dependent; will want to do this on every supported OS

First, run the CMake build with the ``ninja`` generator.

Second run ``ninja -t commands``. This will do a "dry run" of building which prints all commands. This will include linker and compiler output so you get:

- linker flags
- linker inputs
- source files
- compiler flags

This should give you enough information to construct a gn file.

TODO: Can this be scripted?
