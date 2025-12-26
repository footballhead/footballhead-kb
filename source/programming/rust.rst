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

(Just run ``cargo new my_package`` again. This also adds the package as a workspace member in Cargo.toml)

TODO does a package in a workspace need to be a workspace member? Or is the path dependency enough?

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

Build scripts
=============

https://doc.rust-lang.org/cargo/reference/build-scripts.html

Put ``build.rs`` in the root of the package (alongside Cargo.toml). Define ``fn main()``. Tell cargo what you made by printing lines starting with ``cargo::`` (.e.g ``cargo::rerun-if-changed=src/foo.c``). Specify depencencies in ``[build-dependencies]``.

List of build-dependencies: https://crates.io/keywords/build-dependencies . E.g. CMake: https://crates.io/crates/cmake

Can use ``std::process`` to invoke other programs. https://doc.rust-lang.org/std/process/index.html

NOTE if you don't output errors (print ``cargo::error=``) then the build script will be considered successful.

Example
-------

Assuming that your package looks like this::

    package/
        Config.toml
        build.rs
        SDL/     <-- git submodule add https://github.com/libsdl-org/SDL.git
        src/
            lib.rs

Here's an example ``build.rs`` for running cmake:

.. code-block:: rust
    
    // Get build directory from OUT_DIR env var given to us by Cargo
    // Run process: cmake -B${OUT_DIR} -GNinja -DCMAKE_BUILD_TYPE=Debug SDL
    // Run process: cmake --build ${OUT_DIR}
    // Report cmake errors by printing cargo::error=

    fn configure(
        build_dir: &str,
        source_dir: &str,
        generator: &str,
        config: &str,
    ) -> std::io::Result<std::process::Output> {
        // Run CMake using std::process::Command
        return std::process::Command::new("cmake")
            .arg(format!("-B{}", build_dir))
            .arg(format!("-G{}", generator))
            .arg(format!("-DCMAKE_BUILD_TYPE={}", config))
            .arg(source_dir)
            .output();
    }

    fn build(build_dir: &str) -> std::io::Result<std::process::Output> {
        return std::process::Command::new("cmake")
            .args(["--build", build_dir])
            .output();
    }

    fn cargo_error(output: &std::process::Output) {
        // Printing "cargo::error=foo" causes Cargo to halt.
        println!("cargo::error=CMake failed");
        println!(
            "cargo::error=stdout: {}",
            str::from_utf8(output.stdout.as_slice()).unwrap()
        );
        println!(
            "cargo::error=stderr: {}",
            str::from_utf8(output.stderr.as_slice()).unwrap()
        );
    }

    fn main() {
        // OUT_DIR is given to us by Cargo
        let build_dir = std::env::var("OUT_DIR").unwrap();

        let output = configure(&build_dir, "SDL", "Ninja", "Debug").unwrap();
        if !output.status.success() {
            cargo_error(&output);
            return;
        }

        let output = build(&build_dir).unwrap();
        if !output.status.success() {
            cargo_error(&output);
            return;
        }
    }


Calling C code with Foreign Function Interface
==============================================

TODO https://doc.rust-lang.org/nomicon/ffi.html
