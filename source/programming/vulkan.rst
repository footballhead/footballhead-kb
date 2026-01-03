======
Vulkan
======

The latest and greatest from open source graphics.

---------------
Getting Started
---------------

`docs.vulkan.org <https://docs.vulkan.org>`_ is a great starting point since it amalgamates a bunch of info:

-   Specs

    -   Vulkan
    -   HLSL/GLSL

-   Education

    -   Tutorial
    -   Samples

-------
Samples
-------

-   https://github.com/SaschaWillems/Vulkan
-   https://github.com/KhronosGroup/Vulkan-Samples
-   https://github.com/KhronosGroup/glTF-Tutorials
-   https://github.com/google/bigwheels

----------------
High-level Steps
----------------

Vulkan objects that are used together can often be created without knowledge of each other. The hope is that they'll be assembled correctly when submitted. This loosens the order in which they need to be created and allows one object to be reused multiple times in different contexts. Someting can be reused if it's "compatible."

#.  Create :vk:`VkDevice`
#.  All of:

    #.  Create a :vk:`VkSwapchainKHR` and derive a :vk:`VkRenderPass`
    #.  Create a graphics :vk:`VkPipeline`
    #.  Create resources to be used during the frame loop (:vk:`VkCommandBuffer`, :vk:`VkSemaphore`, etc.)

#. Frame loop: acquire, record, submit, present

Device
======

The first major milestone is creating a :vk:`VkDevice` with one or more :vk:`VkQueue` handles. This lets you actually submit work to the GPU.

#.  Find the Vulkan entrypoint :vk:`vkGetInstanceProcAddr`
#.  Create a :vk:`VkInstance`
#.  Find a :vk:`VkPhysicalDevice` and associated queue families that supports graphics and presentation.
#.  Call :vk:`vkCreateDevice` followed by :vk:`vkGetDeviceQueue`

vkGetInstanceProcAddr
---------------------

`Volk`_ uses the term "meta-loader" for code that dynamically loads the `Vulkan Loader`_ and Vulkan function pointers.

This is the `most performant option <https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderApplicationInterface.md#best-application-performance-setup>`_ and doesn't require the `Vulkan SDK`_ to be installed, but is the most involved. You can write this by hand or use something like `Volk`_.

Alternatively, dynamically link the vulkan lib. This is less performant but requires less setup.

#.  Dynamically load the system vulkan loader.

    With SDL, call :sdl:`SDL_Vulkan_LoadLibrary`

    On Windows, call `LoadLibrary`_ with `"vulkan-1.dll"`_.

#.  Get the entry point. See the Vulkan loader docs for more info.

    With SDL, call :sdl:`SDL_Vulkan_GetVkGetInstanceProcAddr`

    On Windows, call `GetProcAddress`_ with `"vkGetInstanceProcAddr"`_

#.  Find the global [1]_ functions. See the loader docs for more info.

    .. code-block:: c

        PFN_vkCreateInstance vkCreateInstance =
            vkGetInstanceProcAddr(VK_NULL_HANDLE, "vkCreateInstance");

vkCreateInstance
----------------

Create a :vk:`VkInstance` and load instance pointers.

#.  Collect layers and extensions

    #.  (Optional) Add validation layer :vk:`VK_LAYER_KHRONOS_validation` for better debugging.

    #.  Extensions should include at least the platform-specific surface extension for WSI. If you're using a library like SDL or GLFW, there's a dedicated function for this.
    
        With SDL, call :sdl:`SDL_Vulkan_GetInstanceExtensions`.

        On Windows, include :vk:`VK_KHR_win32_surface`.

        .. note::

            On macOS, include the :vk:`VK_KHR_portability_enumeration` extension in order to use MoltenVK

#.  (Optional) Add :vk:`VkDebugUtilsMessengerCreateInfoEXT` to :vk:`VkInstanceCreateInfo` pNext for more debug info.

#.  (Optional) Create a :vk:`VkDebugUtilsMessengerEXT` to get validation layer errors

Find a physical device, queue families
--------------------------------------

Find a suitable :vk:`VkPhysicalDevice` and note the queue families for creating the :vk:`VkQueue` that we want.

Work is submitted to the device through one or more queues. The physical device can have many queues; they can be grouped by shared properties. Queues that share properties are said to be part of a family. In Vulkan, you need to decide how many queues you want from which families before creating the device. 

#.  List physical devices with :vk:`vkEnumeratePhysicalDevices`. The instance owns the physical devices and uses them to advertise the Vulkan implementations on your computer (along with their capabilities). This could be a graphics driver for your GPU, or it could be software like MoltenVk. For simplicity, examples often choose the first one. This is a good assumption in desktop towers where there is likely only one GPU. However, sometimes you might have two. For example, a laptop might have a weaker integrated graphics but more powerful discrete graphics; these show up as two devices. There may also be none: your graphics card is too old, you're running macOS without MoltenVK, etc.

    .. warning::

        How does one choose the "best" physical device? E.g. the fastest.

#.  Graphics queues handle rendering primitives. You can query graphics support with :vk:`vkGetPhysicalDeviceQueueFamilyProperties2`; check that queueFamilyProperties.queueFlags contains VK_QUEUE_GRAPHICS_BIT.

#.  Presentation queues handle showing the results to the user. Along with :vk:`vkGetPhysicalDeviceSurfaceSupportKHR`, there are platform-specific APIs that don't require a surface (like :vk:`vkGetPhysicalDeviceWin32PresentationSupportKHR`)

.. note::

    The distinction between graphics and presentation exists because certain applications are headless (no window) but still use the device. The `spec <https://docs.vulkan.org/spec/latest/chapters/VK_KHR_surface/wsi.html#_querying_for_wsi_support>`_ claims that "not all physical devices will include WSI support. Within a physical device, not all queue families will support presentation"

.. note::

    For simple examples, you can use one queue that supports both graphics and presentation. This allows you to use "exclusive" ownership of resources and makes some things easier. However, for large applications, this might not be as efficient.

.. note::

    The graphics queue is implicitly a transfer queue. This is useful later.

#.  Create a :vk:`VkDevice`, and load its functions via :vk:`vkGetDeviceProcAddr`. Then get your queues via :vk:`vkGetDeviceQueue`.

    Devices also support extensions. For WSI you typically need :vk:`VK_KHR_swapchain`

#.  Create a :vk:`VkSurfaceKHR` for WSI. This only requires a :vk:`VkInstance` (and a window).

    For SDL, call :sdl:`SDL_Vulkan_CreateSurface`.

    .. note::

        Normally, the :vk:`VkSurface` is freed with :vk:`vkDestroySurfaceKHR`. However, with SDL, you need to call :sdl:`SDL_Vulkan_DestroySurface` instead.

    For Windows, call :vk:`vkCreateWin32SurfaceKHR` 

Parallelizable Steps
====================

One you have a device, the world is your oyster. We need to prepare for the frame loop. This means we need to do all of the following, roughly in any order:

#.  Create a :vk:`VkSwapchainKHR` and derive a :vk:`VkRenderPass`
#.  Create a graphics :vk:`VkPipeline`
#.  Create resources to be used during the frame loop (:vk:`VkCommandBuffer`, :vk:`VkSemaphore`, etc.)

vkCreateRenderPass
------------------

A :vk:`VkRenderPass` says where to output pixel information. This means it needs an :vk:`VkImage`.

-   With WSI, this means making a :vk:`VkSwapchainKHR`.

    -   To do that, need a :vk:`VkSurfaceKHR`.
    
        -  To do that, need a platform window

#.  The window: do this however the platform dictates. On Windows, call ``CreateWindow``. With SDL, call :sdl:`SDL_CreateWindow`, etc

#.  Create a :vk:`VkSurfaceKHR` with the platform-dependent API. On Windows, call :vk:`vkCreateWin32SurfaceKHR`

#.  Enumerate the swapchain images


VkSurfaceKHR
~~~~~~~~~~~~



.. [1] "global" is used by the code (not docs) to refer to symbols that can be found via :vk:`vkGetInstanceProcAddr` with :vk:`VK_NULL_HANDLE` instead of a valid :vk:`VkInstance`. Currently, they are: :vk:`vkCreateInstance`, :vk:`vkEnumerateInstanceExtensionProperties`, :vk:`vkEnumerateInstanceLayerProperties`, and :vk:`vkEnumerateInstanceVersion`

.. _LoadLibrary: https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibrarya
.. _Volk: https://github.com/zeux/volk
.. _Vulkan SDK: https://vulkan.lunarg.com/sdk/home
.. _Vulkan Loader: https://docs.vulkan.org/guide/latest/loader.html
.. _"vulkan-1.dll": https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderApplicationInterface.md#windows-dynamic-library-usage
.. _GetProcAddress: https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getprocaddress
.. _"vkGetInstanceProcAddr": https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderApplicationInterface.md#indirectly-linking-to-the-loader

--------
MoltenVK
--------

Apple only supports Metal. So MoltenVK rose as a compatability layer to run Vulkan on Metal.

If you're following tutorials, you're likely going to encounter :vk:`vkCreateInstance` failing with this error:

    vkCreateInstance: Found drivers that contain devices which support the portability subset, but the instance does not enumerate portability drivers! Applications that wish to enumerate portability drivers must set the VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR bit in the VkInstanceCreateInfo flags and enable the VK_KHR_portability_enumeration instance extension.

Do what it says. In :vk:`VkInstanceCreateInfo`:

1. Add :vk:`VK_KHR_portability_enumeration` to ppEnabledExtensionNames (and update enabledExtensionCount appropriately)
2. Set flags to VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR
