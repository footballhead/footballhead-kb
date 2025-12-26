========================================
Rust, from a C++ developer's perspective
========================================

Bootstrap ``rustup`` from the installer on their website.

Making a new project::

    cargo new foo
    cd foo
    git init .
    git commit -m "cargo new"

Build with ``cargo build``

-----
rustc
-----

``rustc`` is the rust compiler. You likely don't need to manually invoke it since ``cargo`` will do that for you. However, it's helpful to know the line of where rustc ends and cargo begins.

rustc seems designed to not require complicated build scripts like Make or CMake. ``rustc foo.rs`` will look for ``main()`` in ``foo.rs``. If it's there, rustc will produce and generate ``foo.exe``. It will then spider out from there based on any ``mod foo;`` usage to look for ``foo.rs`` (or ``foo/mod.rs``), and so on.

TODO: does it use caching to make this performant?

Modules
=======

Modules are namespace with visibility.

Can declare multiple modules in the same file with ``mod my_mod {}`` and refer to items via ``my_mod::foo``. Modules can be nested as you would expect with C++ namespaces.

To import a module from another file, use: ``mod my;``. This will literally look for ``my.rs`` or ``my/mod.rs``.  Note that ``my.rs`` doesn't need to wrap its code with ``mod my {}``.

``mod my::nested`` is not valid. Instread, ``my.rs`` (or ``my/mod.rs``) needs to contain ``pub mod nested``; rustc will look for ``my/nested.rs`` (or ``my/nested/mod.rs``).

Alias can be made with ``use``.

Libraries
=========

``rustc --crate-type`` can be used to change what rustc produces. It seems to use ``bin`` by default but can also make:

* ``lib`` (currently an alias for rlib)
* ``rlust``: rust static library
* ``dylib``: rust dynamic library
* ``staticlib``: native static library (e.g. ``.a``)
* ``cdylib``: native dynamic library (e.g. ``.so``)

-----
Cargo
-----

Cargo is the packaging system. It handles installing other packages and invoking ``rustc`` for your package.

Since ``rustc`` does most of the work finding files, Cargo really can't be called a build system like Make or CMake.

You don't need to use Cargo (can just invoke ``rustc``), but it's highly encouraged. That said, I'd encourage experimenting with ``rustc`` to gain a full appreciation for what ``cargo`` gives you.

Config is in Cargo.toml

Hierarchy of terms:

* Workspace
    * Package (workspace member)
        * Target (crate)
            * Modules

Files are `auto-discovered <https://doc.rust-lang.org/cargo/reference/cargo-targets.html#target-auto-discovery>`_. This is a double-edged sword: it makes getting started easy but obscures the internals.

Workspace
=========

TODO https://doc.rust-lang.org/cargo/reference/workspaces.html

A workspace is a collection of packages (called "members").

By defaut, there is no workspace since there's just one package. You need to add ``[workspace]`` to the top of the TOML. When you do, the ``[package]`` becomes the *root package* (I guess the thing that cargo builds and runs). If you want other packages, you need to:

* create new subdirectories for each package
* ensure those subdirectories follows the package layout (i.e. it needs a Cargo.toml)
* to get them build, they need to be path dependencies of the root project
* NOTE: The package is implicitly available for use; don't need to explicitly import it somehow (i.e. no ``mod`` or ``use``).

(Just run ``cargo new my_package`` again)

When all packages are in subdirectories, it's called a "virtual workspace" and the ``members`` field must be specified.

Package
=======

A package can only have one lib target but multiple other targets (bin, example, test, bench). (https://doc.rust-lang.org/cargo/reference/cargo-targets.html#configuring-a-target)

In general, things seem heavily tied to `filesystem layout <https://doc.rust-lang.org/cargo/guide/project-layout.html>`_::

    .
    ├── Cargo.lock
    ├── Cargo.toml
    ├── src/
    │   ├── lib.rs
    │   ├── main.rs
    │   └── bin/
    │       ├── named-executable.rs
    │       ├── another-executable.rs
    │       └── multi-file-executable/
    │           ├── main.rs
    │           └── some_module.rs
    ├── benches/
    │   ├── large-input.rs
    │   └── multi-file-bench/
    │       ├── main.rs
    │       └── bench_module.rs
    ├── examples/
    │   ├── simple.rs
    │   └── multi-file-example/
    │       ├── main.rs
    │       └── ex_module.rs
    └── tests/
        ├── some-integration-tests.rs
        └── multi-file-test/
            ├── main.rs
            └── test_module.rs

Module
======

Visibility mechanism within a target. The build system doesn't seem to care about these. Modules are a Rust concept; cargo doesn't care about them.

Package vs target vs Module
---------------------------

When integrating with a third-party library, which to use? The simplest is module

https://doc.rust-lang.org/cargo/reference/cargo-targets.html#configuring-a-target

https://doc.rust-lang.org/rust-by-example/mod/split.html

Calling CMake from Cargo
------------------------

TODO

Calling C code with Foreign Function Interface
----------------------------------------------

TODO https://doc.rust-lang.org/nomicon/ffi.html
