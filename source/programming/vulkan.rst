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

#.  Bootstrap the Vulkan meta-loader.

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

#.  Collect layers and extensions

    #.  (Optional) Add validation layer :vk:`VK_LAYER_KHRONOS_validation` for better debugging.
    #.  Extensions should include at least the platform-specific surface extension for WSI. If you're using a library like SDL or GLFW, there's a dedicated function for this.
    
        With SDL, call :sdl:`SDL_Vulkan_GetInstanceExtensions`.

        On Windows, include :vk:`VK_KHR_win32_surface`.

        .. note::
            
            On macOS, include the :vk:`VK_KHR_portability_enumeration` extension in order to use MoltenVK

#.  Create a :vk:`VkInstance` and load instance pointers.

    (Optional) Add :vk:`VkDebugUtilsMessengerCreateInfoEXT` to :vk:`VkInstanceCreateInfo` pNext for more debug info.

#.  (Optional) Create a :vk:`VkDebugUtilsMessengerEXT` to get validation layer errors

#.  Create WSI surface. This only requires a :vk:`VkInstance` (and a window); we need supported sizes, formats, and whatnot to create the swapchain later.

    For SDL, call :sdl:`SDL_Vulkan_CreateSurface`.

    .. note::

        Normally, the :vk:`VkSurface` is freed with :vk:`vkDestroySurfaceKHR`. However, with SDL, you need to call :sdl:`SDL_Vulkan_DestroySurface` instead.

    For Windows, call :vk:`vkCreateWin32SurfaceKHR` 

.. code:: c

    // Bootstrap meta loader
    HMODULE vulkan_dll = LoadLibrary("vulkan-1.dll");
    PFN_vkGetInstanceProcAddr vkGetInstanceProcAddr =
        GetProcAddress(vulkan_dll, "vkGetInstanceProcAddr");
    PFN_vkCreateInstance vkCreateInstance =
        vkGetInstanceProcAddr(/*instance=*/VK_NULL_HANDLE, "vkCreateInstance");

    // Collect layers and extensions
    const char* layers[] = { "VK_LAYER_KHRONOS_validation" }; // Optional
    const char* extensions[] = {
        "VK_KHR_win32_surface", // WSI, Win32
        "VK_EXT_debug_utils" // for debug utils messenger (validation layer)
    };

    // Create instance
    VkInstanceCreateInfo instance_create_info = /*...*/;
    // OPTIONAL: Print debug messages during vkCreateInstance
    VkDebugUtilsMessengerCreateInfoEXT debug_messenger_create_info = /*...*/;
    instance_create_info.pNext = &debug_messenger_create_info;
    VkInstance instance = VK_NULL_HANDLE;
    vkCreateInstance(/*...*/, &instance);
    vkDestroyInstance = vkGetInstanceProcAddr(instance, "vkDestroyInstance");
    // ... load other instance functions here

    // TODO: debug messenger

    // Create WSI surface. This is different for each platform.
    HWND window = CreateWindow(/*...*/);
    HINSTANCE hinstance = GetModuleHandle(NULL);
    VkWin32SurfaceCreateInfoKHR surface_create_info = /*...*/;
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    vkCreateWin32SurfaceKHR(/*...*/, &surface);

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
