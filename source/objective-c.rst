Objective-C from a C++ Perspective
==================================

I decided that I wanted to learn Objective C. As a C++ developer, here are the differences I noticed.

Objective-C feels like C++ from another dimension
-------------------------------------------------

Objective-C is just an attempt to add object oriented paradigms to C. It shows; you can see the C parts sticking through the Objective-C parts. But Objective-C loves to pretend that it's not there.

C++ really leaned into the C syntax to create something that feels more harmonius. Objective-C kinda feels like a "fuck you".

Basic Syntax
------------

.. code-block:: objective-c

    // file: cocoa-sample.m
    // (Objective-C files end in .m)
    // This sample creates a window with a close button on macOS.

    // #import instead of #include. This handles include guards automatically.
    #import <Cocoa/Cocoa.h>

    // Delegates are effectively like event handlers or callbacks. The
    // NSApplicationDelegate informs us of lifecycle events and allows us to
    // influence NSApplication behavior.
    //
    // MyApplicationDelegate is a class that inherits from NSObject and adopts
    // the NSApplicationDelegate protocol. NSObject is the parent class of all
    // classes. Protocols are essentially pure virtual interfaces.
    //
    // NS is short for NeXTPSTEP, where most of these APIs were defined.
    //
    // Notice that this is an @interface. It needs an accompanying
    // @implementation. They can be in the same file, or you can put @interface
    // in the .h and the @implementation in the .m
    @interface MyApplicationDelegate : NSObject <NSApplicationDelegate>
    // Each class has the alloc class method and init instance method. alloc is
    // kinda like new, and init is kinda like the constructor.

    // The designated initializer. Our constructor that can take additional
    // parameters.
    // The - means it's an instance method (not "static"). The first argument
    // is called `window` and is of type `NSWindow*`. Additonal parameters are
    // space delimited.
    - (id)initWithWindow:(NSWindow *)window;

    // Other things that could go here: properties, class methods.
    @end

    // This is where the function body goes. Don't need to restate the parent
    // class or interfaces.
    @implementation MyApplicationDelegate {
        // Variables defined in this block are instance variables. They can
        // only be accessed by the implementation of instance methods.
        NSWindow *_window;
    }

    - (id)initWithWindow:(NSWindow *)window {
        // https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Initialization/Initialization.html
        // Always call the super init first.
        self = [super init];
        // super init can return nil (nullptr) so check for it.
        if (self) {
            // Initialize instance variables.
            _window = window;
        }
        return self;
    }

    // Override from NSApplicationDelegate
    - (void)applicationDidFinishLaunching:(NSNotification *)notification {
        // Print a debug message to the terminal.
        // Strings are represented via NSString. @ turns this C string literal into an NSString.
        NSLog(@"applicationDidFinishLaunching");

        [self.window makeKeyAndOrderFront:nil];
        // This is required for making the window pop to the front.
        // https://stackoverflow.com/questions/7460092/nswindow-makekeyandorderfront-makes-window-appear-but-not-key-or-front
        [NSApp activateIgnoringOtherApps:YES];
    }

    // Override from NSApplicationDelegate
    - (BOOL)applicationShouldTerminateAfterLastWindowClosed:
        (NSApplication *)sender {
        // This causes the program to exit when the window is closed.
        // Note that booleans are YES (true) and NO (false).
        return YES;
    }

    @end

    // `main` is still the entrypoint.
    int main(int argc, char **argv) {
        // Make a window.
        // x,y is relative to bottom-left of screen.
        NSRect contentRect = NSMakeRect(/*x=*/0, /*y=*/0, /*w=*/400, /*h=*/300);
        // Make the window with a title bar with a close button.
        NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable;
        // All modes apart from NSBackingStoreBuffered are deprecated.
        // Note the idiom to alloc and init.
        NSWindow *window =
            [[NSWindow alloc] initWithContentRect:contentRect
                                        styleMask:style
                                          backing:NSBackingStoreBuffered
                                            defer:YES];
        window.title = @"macOS Sample";

        // Call NSApplication::sharedApplication() and throw away the return.
        // This initializes the singleton and populates the NSApp global.
        [NSApplication sharedApplication];
        // Let us handle lifecycle events, etc.
        // Note the idiom to alloc and init. Here we use the designated initializer.
        // Equivalent to `MyApplicationDelegate::alloc()->initWithWindow(window);`
        // or, more idiomatically, `new MyApplicationDelegate(window)`;
        NSApp.delegate = [[MyApplicationDelegate alloc] initWithWindow:window];
        // Enter the main event loop. This doesn't return (calls exit() instead).
        [NSApp run];
        // Technically should [my_delegate release] and [window release] but
        // run() never returns.
        return 0;
    }

Compile with ``clang -framework appkit cocoa-sample.m -o cocoa-sample``. `-framework appkit` is basically the same as linking against the AppKit shared object. MacOS likes to be special so all the headers and code (.dylib) are stored in "bundles": prescriptive directory structures. A framework is a kind of bund;e

Most Objective-C is very macOS-specific
---------------------------------------

Most of the classes that you use will be from the Cocoa app framework, designed by Apple. The classes are largely prefixed with NS (short for NeXTSTEP).

For example, using GCC, you:

- Subclass ``Object`` from ``objc/Object.h`` (instead of ``NSObject``)
- Call ``new`` instead of ``alloc``.

``id`` is like a special ``void*`` for objects
----------------------------------------------

``id`` just means "an object" without being specific as to which type. You have to now which type it is and cast to it.

RTTI is the norm
----------------

The Apple docs explain that ``id`` is just a pointer

.. code-block:: c

    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocObjectsClasses.html
    typedef struct objc_object {
        Class isa;
    } *id;

    // "Every object thus has an isa variable that tells it of what class it is
    // an instance. Since the Class type is itself defined as a pointer"
    typedef struct objc_class *Class;

Interfaces are classes
----------------------

Interfaces are classes.

Protocols are pure virtual interfaces
-------------------------------------

Protocols are pure virtual interfaces.

Classes inherit from interfaces but adopt protocols.

"Delegates" are just concrete protocol implementations
------------------------------------------------------

"Delegates" are just concrete protocol implementations

Properties
----------

Properties are kinda like public variables. They have accessors backed by methods (sometimes compiler generated).

Memory Management and Initialization Idioms
-------------------------------------------

Each class defines the ``alloc``, ``init``, ``retain``, and ``release`` methods.

#. alloc (new)
#. init (constructo)
#. retain (increase refcount)
#. release (decrement refcount)

TODO

* ``@autoreleasepool`` (https://stackoverflow.com/questions/14677049/what-is-autoreleasepool)
* NSAutoreleasePool (https://developer.apple.com/documentation/foundation/nsautoreleasepool)
* Automatic reference counting (`Transitioning to ARC Release Notes (2013)`_)

ARC resources:

* Overview: https://en.wikipedia.org/wiki/Automatic_Reference_Counting
* clang docs: https://releases.llvm.org/20.1.0/tools/clang/docs/AutomaticReferenceCounting.html
* Added in 2011 https://theapplewiki.com/wiki/Automatic_Reference_Counting

NIB
---

Apple really wants you to not write code. They want you to build interfaces with Xcode and store them as XML storyboards. Then `main` just bootstraps loading the XML and generating the object graph.

NIB stands for NeXTSTEP Interface Builder, the precursor to what's now in Xcode. It's WYSIWYG GUI development tool. NSBundle has functions designed for loading NIBs to find the storyboard and construct the application.

Bundles
-------

Packages are folders that macOS treats like files (e.g. ``.app``). Bundle is the layout of the package: where does the code and resources go.

E.g. here's the basics layout of any .app:

* Contents/
    * Info.plist (optional)
    * MacOS/
        * my_binary
    * Resources/ (optional)
        * foo.jpg
        * ... etc

Applications launched outside a bundle may not have their windows shown in the doc or brought forward. This is goverened the the activation policy: https://developer.apple.com/documentation/appkit/nsapplication/activationpolicy-swift.enum?language=objc

Info.plist
----------

If you need to embed it for whatever reason:

.. code-block:: cmake

    # https://discourse.cmake.org/t/how-to-embed-info-plist-in-a-simple-mac-binary-file/512
    target_link_options(MyTarget
        PRIVATE
            LINKER:-sectcreate,__TEXT,__info_plist,${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    )

Required and recommended keys are here: https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW1

Here's a example from the Metal 4 Hello Triangle sample:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>en</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIconFile</key>
        <string></string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <string>1</string>
        <key>LSMinimumSystemVersion</key>
        <string>$(MACOSX_DEPLOYMENT_TARGET)</string>
        <key>NSMainStoryboardFile</key>
        <string>Main</string>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
    </dict>
    </plist>



See Also
--------

* `Cocoa Drawing Guide (2012)`_
* `Advanced Memory Management Programming Guide (2012)`_
* `Concepts in Objective-C Programming (2012)`_
* `The Objective-C Programming Language (2013)`_
* `Transitioning to ARC Release Notes (2013)`_
* `Exception Programming Topics (2013)`_
* `Programming with Objective-C (2014)`_
* `Mac App Programming Guide (2015)`_
* `Resource Programming Guide (2016)`_
* `Bundle Programming Guide (2017)`_
* `Information Property List Key Reference (2018)`_
* `Foundation Reference`_
* `AppKit Reference`_

.. _Cocoa Drawing Guide (2012): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40003290
.. _Advanced Memory Management Programming Guide (2012): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011-SW1
.. _Concepts in Objective-C Programming (2012) : https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Initialization/Initialization.html#//apple_ref/doc/uid/TP40010810-CH6-SW1
.. _The Objective-C Programming Language (2013): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html
.. _Transitioning to ARC Release Notes (2013): https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226
.. _Exception Programming Topics (2013): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Exceptions/Exceptions.html#//apple_ref/doc/uid/10000012i
.. _Programming with Objective-C (2014): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011210-CH1-SW1
.. _Mac App Programming Guide (2015): https://developer.apple.com/library/archive/documentation/General/Conceptual/MOSXAppProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010543-CH1-SW1
.. _Resource Programming Guide (2016): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i
.. _Bundle Programming Guide (2017): https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/Introduction/Introduction.html#//apple_ref/doc/uid/10000123i
.. _Information Property List Key Reference (2018): https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html
.. _Foundation Reference: https://developer.apple.com/documentation/foundation?language=objc
.. _AppKit Reference: https://developer.apple.com/documentation/appkit?language=objc
