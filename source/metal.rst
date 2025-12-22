=================================
Metal for a C++, Vulkan Developer
=================================

Metal is Apple's graphics API.

You have three languages:

1. Objective-C (Metal native)
2. C++ bindings
3. swift

I like taking the hard route, which is learning Objective-C.

https://metaltutorial.com/Setup/ uses metal-cpp

https://developer.apple.com/metal/

https://developer.apple.com/documentation/metal?language=objc

https://developer.apple.com/documentation/metal/drawing-a-triangle-with-metal-4?language=objc

"To get an object to do something, you send it a message telling it to apply a method. In Objective-C, message expressions are enclosed in brackets:"

Metal4 sample
=============

Init
----

main.m just calls NSApplicationRun

Info.plist says storyboard is Main.storyboard

Main.storyboard has a viewController element with customClass attribute of ViewController (it also has an application, windowController, window, and view elements)

The viewDidLoad method of ViewController makes a MetalKitViewDelegate

The initWithMetalKitView method of MetalKitViewDelegate makes a Metal4Renderer (or MetalRenderer)

Metal4Renderer accomodates the Renderer protocol. The initWithMetalKitView of Metal4Renderer creates all the primitives.

Render loop
-----------

??? calls the drawInMTKView method of MetalKitViewDelegate

This calls the renderFrameToView method of Metal4Renderer

This calls the command buffer recording and submission