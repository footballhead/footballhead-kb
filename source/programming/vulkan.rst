======
Vulkan
======

The latest and greatest from open source graphics.

---------------
Getting Started
---------------

`docs.vulkan.org <https://docs.vulkan.org>`_ is a great starting point since it amalgamates a bunch of info:

- Specs
    - Vulkan
    - HLSL/GLSL
- Education
    - Tutorial
    - Samples

-------
Samples
-------

- https://github.com/SaschaWillems/Vulkan
- https://github.com/KhronosGroup/Vulkan-Samples
- https://github.com/KhronosGroup/glTF-Tutorials
- https://github.com/google/bigwheels

----------------
High-level Steps
----------------

#. Bootstrap meta-loader. This is the most performant option and doesn't require the SDK to be installed, but you could just dynamically link the vulkan lib. You could also just use Volk.
    #. Dynamically load the system vulkan loader. With SDL, call ``SDL_Vulkan_LoadLibrary()``. On Windows, call ``LoadLibrary("vulkan-1.dll")``. See the Vulkan loader docs for more info.
    #. Get the entry point. With SDL, call ``SDL_Vulkan_GetVkGetInstanceProcAddr()``. On Windows, call ``GetProcAddress()`` with ``"vkGetInstanceProcAddr"``. See the Vulkan loader docs for more info.
    #. Find the global functions. call vkGetInstanceProcAddr with instance = VK_NULL_HANDLE. See the loader docs for more info.
        #. ``PFN_vkCreateInstance vkCreateInstance = vkGetInstanceProcAddr(VK_NULL_HANDLE, "vkCreateInstance");``
#. (WSI) Depending on your library, you might need to create a window to get instance extensions. E.g. SDL_Vulkan_GetInstanceExtensions requires an SDL_Window. If you know your platform already, you might be able to defer this. NOTE: For SDL, ``SDL_CreateWindow`` with ``SDL_WINDOW_VULKAN`` will call ``SDL_Vulkan_LoadLibrary``. If you want to call it (for whatever reason) then make sure to create the window after loading the vulkan lib.
#. Collect layers and extensions
    #. (Optional) add validation layer
    #. Extensions should include WSI like surface. If you're using a library like SDL or GLFW, there's a dedicated function for this. In SDL it's SDL_Vulkan_GetInstanceExtensions
#. Create an instance and load instance pointers. (optional) Add debug utils messenger create info to VkInstanceCreateInfo::pNext for more debug info.
#. (Detour) create WSI

.. code:: c

    // Bootstrap meta loader
    HMODULE vulkan_dll = LoadLibrary("vulkan-1.dll");
    PFN_vkGetInstanceProcAddr vkGetInstanceProcAddr = GetProcAddress(vulkan_dll, "vkGetInstanceProcAddr");
    PFN_vkCreateInstance vkCreateInstance = vkGetInstanceProcAddr(/*instance=*/VK_NULL_HANDLE, "vkCreateInstance");

    // Collect layers and extensions
    const char* layers[] = { "VK_LAYER_KHRONOS_validation" }; // Optional
    const char* extensions[] = { "VK_KHR_win32_surface" }; // Surface extension for WSI. VK_KHR_win32_surface is for Win32 API windows.

    // Create instance
    VkInstance instance = VK_NULL_HANDLE;
    // OPTIONAL: 
    vkCreateInstance(/*...*/, &instance);
    vkDestroyInstance = vkGetInstanceProcAddr(instance, "vkDestroyInstance");
    // ... load other instance functions here


