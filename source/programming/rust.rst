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

--------
Language
--------

Error Handling via returns
==========================

Rust doesn't use exceptions. Instead, functions return any errors that were encountered via ``Result``. This is very similar to ``absl::Status`` and ``absl::StatusOr``:

.. code-block:: c++

    // Authenticates with the ATM. Returns !ok() if authentication failed.
    absl::Status EnterPin(std::string_view pin) {
        if (!IsUserPin(pin)) {
            return absl::UnauthenticatedError("Incorrect PIN")
        }
        return absl::OkStatus();
    }

    // Deducts the requested dollar value from the account and returns a list of bills. Returns !ok() if the withdrawl could not happen.
    absl::StatusOr<std::vector<Bill>> WithdrawFunds(int amount) {
        if (amount <= 0) {
            return absl::InvalidArgumentError("amount must be positive");
        }
        if (amount < GetCurrentBalance()) {
            return absl::FailedPreconditionError("Not enough money in account");
        }
        DeductFunds(amount)
        return FewestBillsForAmount(amount);
    }

The same in Rust:

.. code-block:: rust

    // Result has 2 generic parameters: T for success, E for error.
    // Notice that T here is `()` (the unit type) which essentially means "there is no consumable type on success"
    fn enter_pin(&str pin) -> Result<(), &'static str> {
        if !is_user_pin(pin) {
            return Err("Incorrect PIN");
        }
    }

    fn withdraw_funds(int amount) -> Result<Vec<Bill>, &'static str> {
        if amount <= 0 {
            return Err("amount must be positive");
        }
        if amount < get_current_balance() {
            return Err("Not enough money in account");
        }
        deduct_funds(amount);
        return Ok(fewest_bills_for_amount(amount));
    }

Composing Errors
----------------

Sometimes a function can return more than 1 error. But Result only has 1 error type. What do?

While it doesn't have to, the expectation is that the error type implements ``std::error::Error``. To do this, it must also implement ``Debug`` and ``std::fmt::Display``. This means you need to do these things to define a new error:

1. Define an ``enum FooError`` (variant) containing all your errors
2. ``impl std::error::Error for FooError``
3. ``#[derive(Debug)]`` for ``FooError``
4. ``impl std::format::Display for FooError``; implement ``fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result``

This author recommends defining a custom ``std::error::Error`` using ``enums`` (a.k.a variants) https://www.howtocodeit.com/guides/the-definitive-guide-to-rust-error-handling

.. code-block::

    // Implement Debug
    #[derive(Debug)]
    pub enum UmbrellaError {
        // Put all your errors here
        NulError(std::ffi::NulError),
        SdlError(String),
    }

    // The end goal; requires implemting Debug and Display
    impl std::error::Error for UmbrellaError {}

    // Implement display
    impl std::fmt::Display for UmbrellaError {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            // Just call the fmt function on the errors
            match self {
                UmbrellaError::NulError(err) => write!(f, "{}", err),
                UmbrellaError::SdlError(err) => write!(f, "{}", err),
            }
        }
    }

    // Use Result.map_err to make your error
    let title = std::ffi::CString::new(title).map_err(|x| UmbrellaError::NulError(x))?;

Though they don't recommend umbrella enums. Nor do they recommend an error enum for each function. The answer is somewhere in the middle

Unit type: ``()`` is ``void``
=============================

In Rust, a function that "returns nothing" or "takes nothing" or a generic that "has no type" uses ``()``. Most of the time you can treat this like void ``void`` but, as wikipedia points out, there are some subtle differences: https://en.wikipedia.org/wiki/Unit_type See the ``enter_pin()`` in the previous section.

main is not main
================

In C you're used to:

.. code-block:: c

    int main(int argc, char** argv) {
        return 0;
    }

In Rust, you get this instead:

.. code-block:: rust

    fn main() {
        // Have to go out of the way to get args
        let args: Vec<String> = std::env::args();
        // Have to explicitly exit if you want to control exit code
        std::process::exit(0);
        // Causes immediate termination; nothing runs here!
        // This means that the Vec and String are never `Drop`'d!
    }

You can return a Result though: https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html

.. code-block:: rust

    // Box is scoped, heap allocated memory.
    //
    // dyn means "dynamic dispatch". It's basically like passing a pointer/reference to a pure virtual interface.
    // You're saying "I don't know exactly what this thing is, but it at least adheres to this contract".
    //
    // std::error::Error is an interface for describing errors. Rust uses this to print the error.
    fn main() -> Result<(), Box<dyn std::error::Error>> {
        // This is useful since you can use ? and be lazy with error propagation
        enter_pin("1234")?;
        // ? is shorthand for:
        // match enter_pin() {
        //    Ok(_) => (),
        //    Err(e) => return Err(e),
        // }

        let withdrawn_bills = withdraw_funds(100)?;
        // ? is shorthand for:
        // let withdrawn_bills = match withdraw_funds(00) {
        //    Ok(bills) => bills,
        //    Err(e) => return Err(e),
        // }

        // Notice that you have to be explicit with the success return type now
        Ok(())
    }

You might be able to request rust to give you access to ``pub extern fn main(argc: i32, argv: *const *const u8) -> i32``. But I can't find a lot of info on it:

- https://doc.rust-lang.org/1.7.0/book/no-stdlib.html
- https://docs.rust-embedded.org/book/intro/no-std.html
- https://docs.rust-embedded.org/embedonomicon/smallest-no-std.html

https://www.codestudy.net/blog/why-does-rust-not-have-a-return-value-in-the-main-function-and-how-to-return-a-value-anyway/

-----
rustc
-----

``rustc`` is the rust compiler. You likely don't need to manually invoke it since ``cargo`` will do that for you. However, it's helpful to know the line of where rustc ends and cargo begins.

rustc seems designed to not require complicated build scripts like Make or CMake. ``rustc foo.rs`` will look for ``main()`` in ``foo.rs``. If it's there, rustc will produce and generate ``foo.exe``. It will then spider out from there based on any ``mod bar;`` usage to look for ``bar.rs`` (or ``bar/mod.rs``), and so on.

(This likely uses caching otherwise it wouldn't be very performant...)

Modules
=======

Modules are namespaces with visibility.

Can declare multiple modules in the same file with ``mod my_mod {}`` and refer to items via ``my_mod::foo``. Modules can be nested as you would expect with C++ namespaces.

To import a module from another file in the same crate, use: ``mod my;``. This will literally look for ``my.rs`` or ``my/mod.rs``.  Note that ``my.rs`` doesn't need to wrap its code with ``mod my {}``.

(To import a module from another crate, look Cargo ``[dependencies]`` instead.)

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

Since ``rustc`` does most of the work finding files, Cargo really can't be called a build system like Make or CMake. That said, it does help wrangle other packages so that you can use the,.

You don't need to use Cargo (can just invoke ``rustc``), but it's highly encouraged. I wouldn't want to have depencencies on crates without it. That said, I'd encourage experimenting with ``rustc`` to gain a full appreciation for what ``cargo`` gives you.

Config is in Cargo.toml. Files are `auto-discovered <https://doc.rust-lang.org/cargo/reference/cargo-targets.html#target-auto-discovery>`_. This is a double-edged sword: it makes getting started easy but obscures the internals.

Hierarchy of terms:

* Workspace
    * Package (workspace member)
        * Target (crate)
            * Modules

Workspace
=========

A workspace is a collection of packages (called "members").

By defaut, there is no workspace since there's just one package. You need to add ``[workspace]`` to the top of the TOML. When you do, the ``[package]`` becomes the *root package* (I guess the thing that cargo builds and runs). If you want other packages, you need to:

* create new subdirectories for each package
* ensure those subdirectories follows the package layout (i.e. it needs a Cargo.toml)
* to get them build, they need to be path dependencies of the root project
* NOTE: The package is implicitly available for use; don't need to explicitly import it somehow (i.e. no ``mod`` or ``use``).

(Just run ``cargo new my_package`` again. This also adds the package as a workspace member in Cargo.toml)

TODO does a package in a workspace need to be listed as a workspace member in Cargo.toml? Or is the path dependency enough?

When all packages are in subdirectories, it's called a "virtual workspace" and the ``members`` field must be specified.

Package
=======

A package can only have one lib target but multiple other targets (bin, example, test, bench). (https://doc.rust-lang.org/cargo/reference/cargo-targets.html#configuring-a-target)

In general, things seem heavily tied to `filesystem layout <https://doc.rust-lang.org/cargo/guide/project-layout.html>`_::

    .
    ├── Cargo.lock
    ├── Cargo.toml ..................... Cargo configuration
    ├── src/ ........................... Source files for the package
    │   ├── lib.rs ..................... Default file for lib package
    │   ├── main.rs .................... Default file for bin package
    │   └── bin/ ....................... Other [[bin]] targets
    │       ├── named-executable.rs .... [[bin]] can be one file
    │       ├── another-executable.rs
    │       └── multi-file-executable/ . or [[bin]] can have modules; the folder is the [[bin]] name
    │           ├── main.rs ............ entrypoint for multi-file-executable [[bin]]
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

Build scripts are run before ``rustc`` is run on the package. They are written in Rust.

#. Put ``build.rs`` in the root of the package (alongside Cargo.toml).
#. Define ``fn main()``.
#. Tell cargo what you made by printing lines starting with ``cargo::`` (.e.g ``cargo::rerun-if-changed=src/foo.c``).
#. Specify any ``build.rs`` depencencies in ``[build-dependencies]``.

List of build-dependencies: https://crates.io/keywords/build-dependencies . E.g. CMake: https://crates.io/crates/cmake

Can use ``std::process`` to invoke other programs. https://doc.rust-lang.org/std/process/index.html

NOTE if you don't output errors (print ``cargo::error=``) then the build script will be considered successful.

-----------------------------------------
C Interop with Foreign Function Interface
-----------------------------------------

Can call C from Rust and Rust from C!

Challenges:

* What is the type of a given enum?
* What is the type of a bool?
* How to choose types that are safe independent of OS?

Calling C from Rust
===================

#. Convert the C header into rust types.
#. Wrap in ``unsafe extern "C" {}``. All foreign code is considered ``unsafe`` so needs to be marked as such. ``extern "C"`` sets the calling convetion.
#. Add linker hint to find the C lib.

.. code-block:: rust

    // Windows: look for SDL3.lib. Search path is printed by build.rs
    #[link(name = "SDL3")]
    unsafe extern "C" {
        // Since bool only needs to hold 0 or 1 I think we're free to decide the size
        // TODO: SDL_InitFlags
        pub fn SDL_Init(flags: u32) -> bool;

        pub fn SDL_Quit();
    }

Use ``std::ptr::null_mut`` to get a ``NULL`` ``void*``.

Sometimes, APIs want ``argv`` (e.g. ``SDL_RunApp()``). This is tricky. Rust gives you args via ``std::env::args()`` as a collection of ``String`` (e.g. ``Vec<String>``). However, we need a ``char**``; the Rust equivalent is ``*mut *mut c_char``. Here's what I found to work:

.. code-block:: rust

    using std::ffi::c_char;

    fn main() {
        // 1. Call `std::env::args()` to get the command-line arguments. This
        //    gives us a collection of `String`.
        // 2. Convert `String` into `*mut c_char` via `CString::into_raw()`.
        //    `CString` allocates a new null-terminated string.
        //    `CString::into_raw()` releases a `*mut char`. Note that we now
        //    have the obligation to call `CString::from_raw()` later so that the
        //    memory can be freed. AFAICT it's safe to do this despite `CString`
        //    being a temporary since the memory has already been allocated and
        //    the ownership has been transferred.
        // 3. Convert `Vec<*mut c_char>` into `*mut *mut c_char` via
        //    `Vec<T>::as_mut_ptr()`
        let mut args: Vec<*mut c_char> = std::env::args()
            .map(|x| CString::new(x).unwrap().into_raw())
            .collect();
        let argv: *mut *mut c_char = args.as_mut_ptr();

        let argc: c_int = args.len().try_into().unwrap();

        unsafe {
            // Call the function that wants argv
            sdl::SDL_RunApp(argc, argv, run_app_callback, ptr::null_mut());

            // Regain char* so it can be properly freed
            let _: Vec<CString> = args.iter().map(|x| CString::from_raw(x.clone())).collect();
        }
    }

Can use build scripts to compile the C dependency as part of ``cargo build``

Calling Rust from C
===================

Need to use ``lib.crate-type = ["cdylib"]`` to make a .so/.DLL

Declare functions with the right calling convention and C symbols (no mangling):

.. code-block:: rust

    use std::ffi;

    #[unsafe(no_mangle)]
    extern "C" fn SDL_AppIterate(_appstate: *mut c_void) -> c_char {
        println!("SDL_AppIterate");
        // Only iterate once
        return 1; // SDL_APP_SUCCESS
    }

Then you can link with C code. You likely need to do this in another build system (e.g. Make, CMake).

Building
========

Two approaches:

1. Build with ``cargo build``; write build.rs for dependencies
2. Build with another system (like CMake); create a target that invokes ``cargo build`` and depends on the output.

Build with cargo build
----------------------

Assuming that your package looks like this::

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

Build with cmake
----------------

Assuming that your package looks like this::

    SDL/ ................... git submodule add https://github.com/libsdl-org/SDL.git
    rust/ .................. cargo package called "rust_vulkan_win32_take2"
    main.c ................. main()

Here's a CMakeLists.txt:

.. code-block:: cmake

    # 3.31 is current Debian stable
    # NOTE: This has a lot of Windows-isms right now, could be made more
    # cross-platform. But, as an example, I think you get the picture.
    cmake_minimum_required(VERSION 3.31)
    project(sample_link_c_and_rust)

    # Build SDL lib. Fortunately, can just use their CMakeLists.txt
    add_subdirectory(SDL EXCLUDE_FROM_ALL SYSTEM)

    # Build our rust code by invoking cargo build. We use --manifest-path to
    # avoid changing WORKING_DIRECTORY and --target-dir to put the output into
    # CMAKE_CURRENT_BINARY_DIR (the default is
    # ${CMAKE_CURRENT_SOURCE_DIR}/rust/target and I don't want a dirty source tree)
    # NOTE: The name of the rust package is rust_vulkan_win32_take2.
    # TODO: This invokes cargo directly, should likely try to find cargo first
    add_custom_command(
        OUTPUT
            rust/debug/rust_vulkan_win32_take2.dll.lib
            rust/debug/rust_vulkan_win32_take2.dll
        COMMAND cargo build --manifest-path "${CMAKE_CURRENT_SOURCE_DIR}/Cargo.toml" --target-dir rust
        DEPENDS
            src/lib.rs
            Cargo.toml
            Cargo.lock
    )
    add_custom_target(BuildRustWithCargo DEPENDS rust/debug/rust_vulkan_win32_take2.dll.lib)

    # Import cargo build artifacts into CMake a linkable library target.
    # add_dependency() so that `cargo build` becomes part of the build graph.
    add_library(rust_lib SHARED IMPORTED)
    set_target_properties(rust_lib PROPERTIES
        IMPORTED_IMPLIB "${CMAKE_CURRENT_BINARY_DIR}/rust/debug/rust_vulkan_win32_take2.dll.lib"
        IMPORTED_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/rust/debug/rust_vulkan_win32_take2.dll"
    )
    add_dependencies(rust_lib BuildRustWithCargo)

    # Link together users of Rust (main.c) and Rust definitions (rust_lib).
    add_executable(rust_vulkan_win32_take2 main.c)
    target_link_libraries(rust_vulkan_win32_take2
        PRIVATE
            SDL3::SDL3
            rust_lib
    )

    # Copy DLLs into the same dir as the EXE so we can run. This is an annoying part of
    # Windows (which could be solved by setting the PATH I suppose but whatever)
    add_custom_command(
        OUTPUT SDL3.dll
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${CMAKE_CURRENT_BINARY_DIR}/SDL/SDL3.dll" "${CMAKE_CURRENT_BINARY_DIR}/SDL3.dll"
        DEPENDS SDL/SDL3.dll
    )
    add_custom_target(CopySDL DEPENDS SDL3.dll)
    add_custom_command(
        OUTPUT rust_vulkan_win32_take2.dll
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${CMAKE_CURRENT_BINARY_DIR}/rust/debug/rust_vulkan_win32_take2.dll" "${CMAKE_CURRENT_BINARY_DIR}/rust_vulkan_win32_take2.dll"
        DEPENDS rust/debug/rust_vulkan_win32_take2.dll
    )
    add_custom_target(CopyRustLib DEPENDS rust_vulkan_win32_take2.dll)
    add_dependencies(rust_vulkan_win32_take2 CopySDL CopyRustLib)

bindgen
=======

Making your own bindings is tedious and frought:

- All functions, structs, typedefs need Rust equivalents
- Need to know a lot of low level C details that change depending on the platform. What is the type of a given enum? how is struct packing and alignment handled? What's the calling convention?

bindgen steps in to fill these gaps.

Reference: https://docs.rs/bindgen/latest/bindgen/

User guide: https://rust-lang.github.io/rust-bindgen/

Setup
-----

bindgen needs Clang. On windows, can download from github. If you install to the default directory, bindgen can auto find clang.dll

Basics
------

Two ways of running:

1. Manually via bindgen-cli. Can run once and check in the wrappings, provided that the C lib doesn't change.
2. Automatically via build scripts. Can run every build to ensure that the bindings stay up-to-date.

Build scripts
-------------

Add bindgen to ``[build-dependencies]``

Two steps:

#. Use a ``bindgen::Builder`` to make ``bindgen::Bindings``
#. Write ``bindgen::Bindings`` to disk

``bindgen::Builder`` defines a Fluent interface. The C input goes into ``header()``. Then call ``generate()``. Once you have bindings, write them to a file so that you can use them.

.. code-block:: rust

    // builder() makes a Builder. Could also use Builder::default()
    let bindings: bindgen::Bindings = bindgen::builder()
        // Specify a header. For best results, consider a file in your package
        // which does `#include <foo.h>`. This lets you rely on the clang to
        // track down the exact location of foo.h (which can vary depending on
        // platform.)
        .header("wrapper.h")
        // Make the bindings
        .generate()?;

    bindings.write_to_file("bindings.rs")?;

If you're making a build script, bindings.rs typically goes in the OUT_DIR. Also, you should tell Cargo where to find the lib in order for your program to link.

.. code-block:: rust

    use std::env;
    use std::path::PathBuf;

    fn main() {
        let bindings = bindgen::builder()
            .header("wrapper.h")
            .generate()
            .expect("Failed to make bindings for wrapper.h");
        
        let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap())
        bindings.write_to_file(out_dir.join("bindings.rs"))

        // Required for the program to link. Where is the lib, and what's the name.
        println!("cargo:rustc-link-search=/path/to/lib");
        println!("cargo:rustc-link-lib=SDL3");
    }

wrapper.h doesn't need to be complicated:

.. code-block:: C

    // If clang can't find this, consider adding -I/path/to/include via bindgen::Builder::clang_arg()
    #include <SDL/SDL3.h>

Since bindings.rs is in your OUT_DIR, can't just ``mod bindings``. Instead, you can ``include!`` it wherever you like. Consider disabling some Rust warnings.

.. code-block:: rust

    // Ignore rust style guidance like https://rust-lang.github.io/rust-bindgen/tutorial-4.html
    #![allow(non_upper_case_globals)]
    #![allow(non_camel_case_types)]
    #![allow(non_snake_case)]
    // This is a binding, we're not guaranteed to use all functions
    #![allow(dead_code)]

    // Generated by build.rs
    include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
