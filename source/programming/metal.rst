=================================
Metal for a C++, Vulkan Developer
=================================

Metal is Apple's graphics API.

You have three languages:

1. Objective-C (Metal native)
2. C++ bindings (``metal-cpp``)
3. swift

Getting Started
===============

The command-line tools don't provide the Metal shader compilers. From what I can tell, you can only get this after you install Xcode.

#. Install Xcode (from app store, etc)
#. ``xcodebuild -downloadComponent MetalToolchain``
#. ``xcrun metal`` to verify that it installed

TODO: Can this be installed without xcode?

Metal4 sample
=============

https://developer.apple.com/documentation/metal/drawing-a-triangle-with-metal-4?language=objc

This sample requires XCode to build.

NOTE: The zip contains a git repo????

Init
----

main.m just calls NSApplicationMain

NSApplicationMain loads NIB and calls run

.. code-block:: objective-c

    // https://developer.apple.com/documentation/appkit/nsapplication?language=objc
    void NSApplicationMain(int argc, char *argv[]) {
        [NSApplication sharedApplication];
        [NSBundle loadNibNamed:@"myMain" owner:NSApp];
        [NSApp run];
    }

loadNibNamed will reconstitute Main.storyboard (found via Info.plist)

Main.storyboard creates:

* a NSApplication
* a NSWindowController and NSWindow
* a ViewController (custom class) and MTKView

ViewController is-a NSViewController. The viewDidLoad method of ViewController makes a MetalKitViewDelegate using the superclass `view` property.

The initWithMetalKitView method of MetalKitViewDelegate makes a Metal4Renderer (or MetalRenderer)

Metal4Renderer adopts the Renderer protocol. The initWithMetalKitView of Metal4Renderer creates all the primitives.

Render loop
-----------

??? calls the drawInMTKView method of MetalKitViewDelegate

This calls the renderFrameToView method of Metal4Renderer

This calls the command buffer recording and submission

CMakeLists.txt
--------------

As a fun exercise, and to dispell the magic, I rewrote the Xcode build in CMakeLists.txt. Generating a working application bundle requires

#. Compiling the storyboard (the UI)
#. Compiling the shaders
#. Compiling the Objective-C code
#. Putting the compiled shaders and storyboard in the Resources folder
#. Fixes for Info.plist and the application bundle dir to make the clean target work as expected.

CMake will generate an app bundle if the executable has the MACOSX_BUNDLE property set. By default, this will create an Info.plist and put the built executable in the appropriate folder. You can specify the Info.plist be made based on a template (set via the MACOSX_BUNDLE_INFO_PLIST property) or generated from new based on properties. Resources must be specified both in the executable sources and in the RESOURCES property. To put things in subdirectories of the Resource folder, need to use ``set_source_files_properties(foo PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/bar")``.

(I would have used make but it really doesn't like spaces in filenames)

.. code-block:: cmake

    # Prefer CMake over a Makefile since the folders have spaces in the name.
    cmake_minimum_required(VERSION 3.31)
    project(HelloTriangle C OBJC)

    #
    # Storyboard
    #

    # macOS UI layouts are crafted in a WYSIWYG editor then serialized to disk as separate resource files.
    # While I compare this to XAML or Android layouts, this paradigm that macOS adptoped came from NeXTSTEP.
    # Storyboards were released in 10.10 as an evolution of the existing NIB/XIB design that originated
    # from NeXTSTEP; the IB is short for Interface Builder, which is the tool one would use to craft
    # layouts before Xcode came along.
    #
    # Storyboards in source are XML files. However, they need to be compiled before the program can load them.
    # On the command-line, we can use `ibtool` to do this. This takes the single storyboard file and splits
    # out a "package", or a directory with multiple associated files that act as a single entity.
    #
    # This assumes that you have these tools in your PATH already, i.e. from command-line tools.
    find_program(IBTOOL ibtool REQUIRED)
    add_custom_command(
        # While ibtool produces a package, CMake only works on individual files. Thus we need to express each
        # file in the package here. The one storyboard file is turned into separate nib files (looks like one
        # for each scene element) with an Info.plist (which I think is basically metadata).
        OUTPUT
            Main.storyboardc/Info.plist
            Main.storyboardc/MainMenu.nib
            Main.storyboardc/NSWindowController-B8D-0N-5wS.nib
            Main.storyboardc/XfG-lQ-9wD-view-m2S-Jp-Qdl.nib
        # This command is run at build time in the build folder so input should be absolute
        COMMAND "${IBTOOL}" "${PROJECT_SOURCE_DIR}/UI/macOS/Base.lproj/Main.storyboard" --compile Main.storyboardc
        DEPENDS UI/macOS/Base.lproj/Main.storyboard
        # CMake won't clean up this directory unless we tell it. The clean target will fail if this is not empty.
        BYPRODUCTS Main.storyboardc
    )
    add_custom_target(MainStoryboard DEPENDS
        Main.storyboardc/Info.plist
        Main.storyboardc/MainMenu.nib
        Main.storyboardc/NSWindowController-B8D-0N-5wS.nib
        Main.storyboardc/XfG-lQ-9wD-view-m2S-Jp-Qdl.nib
    )

    # During build and install, make sure the package files are put back into the package
    # in the application bundle resources. Again, CMake doesn't like that this is a directory
    # so we need to specify every file.
    set_source_files_properties(Main.storyboardc/Info.plist PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources/Main.storyboardc"
    )
    set_source_files_properties(Main.storyboardc/MainMenu.nib PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources/Main.storyboardc"
    )
    set_source_files_properties(Main.storyboardc/NSWindowController-B8D-0N-5wS.nib PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources/Main.storyboardc"
    )
    set_source_files_properties(Main.storyboardc/XfG-lQ-9wD-view-m2S-Jp-Qdl.nib PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources/Main.storyboardc"
    )

    #
    # Shaders
    #

    # Shaders for metal are compiled with the `metal` CLI tool. This is part of the Xcode metal toolchain.
    # As such, you can find the `metal` program using `xcrun` (it's not installed in your PATH).
    # 
    # TODO: Should test `xcrun metal` to ensure it actually works. Otherwise we should instruct the user to install.
    find_program(XCRUN xcrun REQUIRED)
    add_custom_command(
        OUTPUT default.metallib
        # While default.metallib is the default output name, we should probably be explicit here (in
        # case it changes in the future)
        COMMAND "${XCRUN}" metal "${PROJECT_SOURCE_DIR}/Shaders/Shaders.metal"
        # TODO what is Descriptors.mtl4-json?
        DEPENDS Shaders/Shaders.metal Shaders/ShaderTypes.h Shaders/Descriptors.mtl4-json
    )
    add_custom_target(MetalShaders DEPENDS default.metallib)

    #
    # Info.plist that is installed after clean properly
    #

    # Info.plist contains metadata about the program, some of which is important for launching the
    # application (i.e. which binary, which storyboard file).
    #
    # CMake will copy/create an Info.plist for you, but only during configure time. If you delete the
    # app bundle as part of clean (like I think you should) then this won't be installed the next build
    # and the app won't work. So use a custom command/target to make sure it's always there/
    #
    # For some reason, can't use Info.plist as the path:
    # ninja: error: 'Info.plist', needed by 'CMakeFiles/AppInfo', missing and no known rule to make it
    # Any other path works.
    add_custom_command(
        OUTPUT generated/Info.plist
        COMMAND "${CMAKE_COMMAND}" -E copy_if_newer "${PROJECT_SOURCE_DIR}/Application/macOS-Info.plist" generated/Info.plist
        DEPENDS Application/macOS-Info.plist
    )
    add_custom_target(AppInfo DEPENDS generated/Info.plist)
    set_source_files_properties(generated/Info.plist PROPERTIES
        MACOSX_PACKAGE_LOCATION ""
    )

    # TODO: Additional rules to process info.plist
    # NOTE: CMake configure_file() and file(CONFIGURE) only do ${VAR} or @VAR@ subtitution.
    # TODO substitution
    # sed -i '' 's/$$(EXECUTABLE_NAME)/Hello Triangle/' "$@"
    # sed -i '' 's/$$(PRODUCT_BUNDLE_IDENTIFIER)/com.example.apple-samplecode.HelloTriangle/' "$@"
    # sed -i '' 's/$$(PRODUCT_NAME)/Hello Triangle/' "$@"
    # sed -i '' 's/$$(MACOSX_DEPLOYMENT_TARGET)/12.0/' "$@"

    #
    # App bundle
    #

    add_executable(HelloTriangle
        Application/main.m
        # Metal 4 Renderer used for non-simulator on MacOS 26+
        "Metal 4 Renderer/Metal4Renderer.m"
        "Metal 4 Renderer/Metal4Renderer+Compilation.m"
        "Metal 4 Renderer/Metal4Renderer+Encoding.m"
        "Metal 4 Renderer/Metal4Renderer+Setup.m"
        # Metal Renderer is a fallback if Metal 4 Renderer is not used
        "Metal Renderer/MetalRenderer.m" 
        "Metal Renderer/MetalRenderer+Compilation.m"
        "Metal Renderer/MetalRenderer+Setup.m"
        "Renderer common/TriangleData.c"
        "View controller/ViewController.m"
        "View controller/MetalKitViewDelegate.m"
        # Resources must both listed as a source and in the RESOURCE property.
        # Make sure MainStoryboard, AppInfo, and MetalShaders are dependencies.
        # Again, for packages, need to list out every file (can't just use the dir name)
        Main.storyboardc/Info.plist
        Main.storyboardc/MainMenu.nib
        Main.storyboardc/NSWindowController-B8D-0N-5wS.nib
        Main.storyboardc/XfG-lQ-9wD-view-m2S-Jp-Qdl.nib
        default.metallib
        generated/Info.plist
    )
    # The imports in the sample don't use paths relative to the repo root, so adding the
    # subdirectories to the include path is necessary to find all the headers.
    target_include_directories(HelloTriangle PRIVATE
        "Metal 4 Renderer"
        "Metal Renderer"
        "Renderer common"
        Shaders
    )
    set_target_properties(HelloTriangle PROPERTIES
        # Try to match Xcode output by rename the executable
        OUTPUT_NAME "Hello Triangle"
        # This binary will be packaged as part of an app bundle.
        MACOSX_BUNDLE TRUE 
        # List all source files that you want to be put in the bundle resource folder.
        # Don't use MACOSX_BUNDLE_INFO_PLIST etc because we have our own (see AppInfo)
        # TODO: Why don't we need to put the storyboardc, etc. files here as well?
        RESOURCE default.metallib
        # CMake doesn't clean the bundle dir for some reason. Listing it here causes it to be cleaned.
        # This creates our Info.plist dilemma; see the AppInfo target for more info.
        ADDITIONAL_CLEAN_FILES "Hello Triangle.app"
    )
    # The sample requires some #defines to ensure we compile for desktop.
    target_compile_definitions(HelloTriangle PRIVATE TARGET_MACOS=1 TARGET_OS_SIMULATOR=0)
    # The sample uses @import to enable module support
    target_compile_options(HelloTriangle PRIVATE -fmodules)
    # NOTE: Without `-framework MetalKit` there is a runtime error when compiled with debug and run in lldb
    # "Unknown class 'MTKView' in Interface Builder file"
    target_link_libraries(HelloTriangle PRIVATE "-framework AppKit" "-framework MetalKit")
    # The app requires that the storyboard and shaders are compiled, and Info.plist is up-to-date
    add_dependencies(HelloTriangle MainStoryboard MetalShaders AppInfo)
    # BUNDLE DESTINATION is required for install(). The user should install with --prefix
    install(TARGETS HelloTriangle BUNDLE DESTINATION .)

See Also
========

* A tutorial that uses metal-cpp: https://metaltutorial.com/Setup/ uses metal-cpp
* Apple Developer landing page: https://developer.apple.com/metal/
* Metal reference docs: https://developer.apple.com/documentation/metal?language=objc
