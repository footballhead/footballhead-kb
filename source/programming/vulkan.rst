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

#.  (WSI) Depending on your library, you might need to create a window to get instance extensions. E.g. :sdl:`SDL_Vulkan_GetInstanceExtensions` requires an :sdl:`SDL_Window`. If you know your platform already, you might be able to defer this.

    .. note::
        
        With SDL, :sdl:`SDL_CreateWindow` with :sdl:`SDL_WINDOW_VULKAN` will call :sdl:`SDL_Vulkan_LoadLibrary`. If you want to call it (for whatever reason) then make sure to create the window after loading the vulkan lib.

#.  Collect layers and extensions

    #.  (Optional) Add validation layer
    #.  Extensions should include WSI like surface. If you're using a library like SDL or GLFW, there's a dedicated function for this. In SDL, it's :sdl:`SDL_Vulkan_GetInstanceExtensions`.

        .. note::
            
            On macOS, include the :vk:`VK_KHR_portability_enumeration` extension in order to use MoltenVK

#.  Create an instance and load instance pointers.

    (optional) Add debug utils messenger create info to :vk:`VkInstanceCreateInfo` pNext for more debug info.

#.  (Optional) Create a :vk:`VkDebugUtilsMessengerEXT` to get validation layer errors

#.  (Detour) Create WSI surface. This isn't necessary if you're headless but is something you likely want to do and can do now that you have an instance. This can be deferred until right before the rendering loop.

.. code:: c

    // Bootstrap meta loader
    HMODULE vulkan_dll = LoadLibrary("vulkan-1.dll");
    PFN_vkGetInstanceProcAddr vkGetInstanceProcAddr =
        GetProcAddress(vulkan_dll, "vkGetInstanceProcAddr");
    PFN_vkCreateInstance vkCreateInstance =
        vkGetInstanceProcAddr(/*instance=*/VK_NULL_HANDLE, "vkCreateInstance");

    // Collect layers and extensions
    const char* layers[] ={ "VK_LAYER_KHRONOS_validation" }; // Optional
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