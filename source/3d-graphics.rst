Modern 3D Graphics in a Nutshell
================================

There are three major modern graphics APIs:

#. Direct3D 12 (a.k.a DirectX 12, DX12, D3D12) - Microsoft - Windows - C++
#. Metal - Apple - macOS - Objective-C/Swift/C++
#. Vulkan - Khronos - Cross-platform - C

Fortunately, at a high level, they all use similar concepts; learning one gives you a huge leg up in learning the other. I wish to highlight those similarities here. You may find yourself making a game on Windows with Direct3D 12 but need to port it to macOS.

(From my experience, Vulkan is the hardest since it is more explicit than the other APIs. But it's the most cross-platform of the three.)

(There's also WebGPU but I don't have a lot of experience with it so can't comment. And OpenGL is popular but works slightly differently.)

Device
------

The first thing you need is a device. This represents your app's use of the GPU.

Vulkan and Direct3D 12 require you to know up front which graphics card you want to use. Vulkan calls these physical devices; Direct3D 12 calls them adapters. In a desktop, there's likely only 1 graphics card. However, some computers have multiple! For example, I have a laptop with both an integrated and dedicated GPU; I may want to use the integated for applications that play video, or the dedicated GPU for video games. You might also want to choose a software renderer in niche scenarios.

In Direct3D 12, you use DGXI to get the adapter, then call ``D3D12CreateDevice()``:

.. code-block:: c++

    // If you're new to COM, here's a primer: it's IPC that dates back to early versions of windows (think 3.1 or 95).
    // It effectively adds objects to C. Each object implements one or more interfaces, each represented by a UUID.
    // Being C, it has explicit ref counting via AddRef and Release.
    //
    // ComPtr is a smart pointer that does the AddRef and Release for you.
    //
    // IID_PPV_ARGS is a quirk of how COM is implemented in C. It does better type checking. Read more about it here:
    // https://learn.microsoft.com/en-us/windows/win32/LearnWin32/com-coding-practices#the-iid_ppv_args-macro
    // My guess is the name is short for "Interface IDenfifier and Pointer to Pointer to Void for ARGuments"
    
    // TODO: The new hotness is winrt::com_ptr.
    using Windows::WRL::ComPtr;

    // featureLevel is the D3D version you want, e.g. D3D_FEATURE_LEVEL_12_0 for 12.0
    ComPtr<ID3D12Device> MakeDevice(D3D_FEATURE_LEVEL feature_level) {
        // DXGI can tell us which adapters are available. DXGI has similarties to Vulkan WSI, which I'll
        // cover in a later section.
        ComPtr<IDXGIFactory4> factory;
        UINT factory_flags = /*...*/;
        CreateDXGIFactory2(factory_flags, IID_PPV_ARGS(&factory));

        // Find the adapter that's right for you.
        ComPtr<IDXGIAdapter1> adapter;
        for (UINT index = 0; factory->EnumAdapters1(index, &adapter) != DXGI_ERROR_NOT_FOUND; ++index) {
            // Filter for a adapter based on your criteria. Typically, this means
            // ignoring the software renderer.
        }

        // Finally, create the device.
        ComPtr<ID3D12Device> device;
        D3D12CreateDevice(adapter, feature_level, IID_PPV_ARGS(&device));
        return device;
    }

In Metal, it's comically easy to get a device with ``MTLCreateSystemDefaultDevice()``.

.. code-block:: Objective-C

    id<MTLDevice> MakeDevice() {
        return MTLCreateSystemDefaultDevice();
    }

In Vulkan, you need to first create an instance, then find the right physical device, then decide how many queues you want before creating a device.

.. code-block:: c

    VkDevice MakeDevice() {
        // Create an instance, which is the entrypoint into the rest of the API.
        VkInstance instance = VK_NULL_HANDLE;
        VkInstanceCreateInfo instance_create_info = /*...*/;
        vkCreateInstance(&instance_create_info, /*pAllocator=*/NULL, &instance);

        // Find the physical device that's right for you.
        VkPhysicalDevice physical_device = VK_NULL_HANDLE;
        // Use vkEnumeratePhysicalDevices to list all physical devices.
        // Then, query the physical device for the desired properties. This is
        // likely based on what surface you're using. I'll talk more about surfaces
        // in a later section.

        // I'm skipping queue creation, see the Queue section.

        VkDevice device = VK_NULL_HANDLE;
        VkDeviceCreateInfo device_create_info = /*...*/;
        vkCreateDevice(physical_device, &device_create_info, /*pAllocator=*/NULL, &device);
        return device;
    }

Queue
-----

After you get a device, you need some way to tell it what to do. The queue is the mechanism that you use to submit work.

In Direct3D 12, call ``ID3D12Device::CreateCommandQueue()``:

.. code-block:: C++

    ComPtr<ID3D12CommandQueue> MakeQueue(ID3D12Device* device) {
        ComPtr<ID3D12CommandQueue> command_queue;
        D3D12_COMMAND_QUEUE_DESC queue_description = /*...*/;
        device->CreateCommandQueue(&queue_description, IID_PPV_ARGS(&command_queue));
        return command_queue;
    }

In Metal, call the device's ``newCommandQueue:`` method.

.. code-block:: Objective-C
    
    id<MTLCommandQueue> MakeQueue(id<MTLDevice> device) {
        return [device newCommandQueue];
    }

In Vulkan, you specify which queues to create during ``vkCreateDevice()`` as a part of ``VkDeviceCreateInfo::pQueueCreateInfos``. As in the previous section, it is a fairly involved:

.. code-block:: c

    // queue_family_index was omitted from the previous section. A graphics card has many queues that
    // are grouped together by shared properties. Queues that share the same properties are part of a
    // "family". Finding the right family is involved so is omitted for the brevity of the example.

    // For most applications, you just need 1 graphics queue.

    struct DeviceAndQueue {
        VkDevice device;
        VkQueue queue;
    };

    // Building on the previous section, assume you have a physical_device and queue_family_index.
    DeviceAndQueue MakeDeviceWithQueue(VkPhysicalDevice physical_device, uint32_t queue_family_index) {
        VkDeviceQueueCreateInfo queue_create_info = /*...*/;
        // Tell Vulkan that we want 1 queue from the given queue family.
        queue_create_info.queueFamilyIndex = queue_family_index;
        queue_create_info.queueCount = 1;

        // Queues are created at the same time as the device.
        VkDevice device = VK_NULL_HANDLE;
        VkDeviceCreateInfo device_create_info = /*...*/;
        device_create_info.queueCreateInfoCount = 1;
        device_create_info.pQueueCreateInfos = &queue_create_info;
        vkCreateDevice(physical_device, &device_create_info, /*pAllocator=*/nullptr, &device);

        // Since we created one queue for the given queue family, now we can retrieve it.
        VkQueue queue = VK_NULL_HANDLE;
        vkGetDeviceQueue(device, queue_family_index, /*queue_family_index=*/0, &queue);

        return {device, queue};
    }

Commands
--------

In order to tell the GPU what to do, you submit commands to the queue. Multiple commands are batched into a single buffer for efficient submission.

In Direct3D 12, these are called command lists::

.. code-block:: c++

    // TODO

In Metal, you create command buffers right from the queue with ``commandBuffer:``. You record commands with a command encoder. Then you commit the buffer.

.. code-block:: objective-c

    // TODO

In Vulkan, you allocate command buffers from a pool then record a sequence of commands like "start render pass", "bind this vertex data", "draw some triangles". The buffer is then submitted to the queue.

.. code-block:: c

    void Render(VkQueue queue, VkCommandBuffer command_buffer) {
        VkCommandBufferBeginInfo begin_info = /*...*/;
        vkBeginCommandBuffer(command_buffer, &begin_info);

        // Record commands with vkCmd*(), like: vkCmdBeginRendering(), vkCmdDraw(), etc

        vkEndCommandBuffer(command_buffer);

        VkSubmitInfo submit_info = /*...*/;
        submit_info.commandBufferCount = 1;
        submit_info.pCommandBuffers = &command_buffer;
        vkQueueSubmit(queue, /*submitCount=*/1, &submit_info, /*fence=*/VK_NULL_HANDLE);
    }

Synchronization
---------------

You can kind of think of the GPU as a different thread. And it's hungry! Once you submit work to it, it goes off and asynchronously starts chewing on the data. That leaves the CPU free to do... whatever it wants. But it won't be long until the GPU needs more. That means that you need some way to know when the GPU needs to be fed more data.

Vulkan has timeline semaphores, which are similar to Direct3D 12 fences, which are similar to Metal sync events.

Vulkan also has binary semaphores which control GPU dependencies between commands within a command buffer, and fences for more explicit CPU-GPU synchronization.

Graphics and Compute Pipelines
------------------------------

Most of the time, you want to draw something like scene composed of triangles and textures. This is what the graphics pipeline is designed for.

Other times (sometimes alongside the graphis pipeline) you want to crunch a lot of numbers or do some other parallelizable math. This can be done with a compute pipeline.

Presentation
------------

Counterintuitively, you can use the graphics card without outputting to the screen. For example, you can draw a scene to memory then store it on disk as a PNG.

However, most of the time, you want to show the thing that you rendered to the user. This means you need some way to integrate with the operating system's windowing system so you can get a panel in a window and draw based on the monitor's refresh rate.

Vulkan calls this the Windowing System Integration (WSI). The setup is quite involved: after you create an instance, you need to create a surface (tied to a window) then a swapchain based on the surface. From the swapchain, you can get images to which you can draw. After you've drawn (by recording commands into a command buffer then submitting to your queue) you then need to explicitly present.


