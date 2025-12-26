Modern 3D Graphics in a Nutshell
================================

There are three major modern graphics APIs:

#. Direct3D 12 (a.k.a DirectX 12, DX12, D3D12) - Microsoft - Windows - C++
#. Metal - Apple - macOS - Objective-C/Swift/C++
#. Vulkan - Khronos - Cross-platform - C

Fortunately, at a high level, they all use similar concepts; learning one gives you a huge leg up in learning the other. I wish to highlight those similarities here. You may find yourself making a game on Windows with Direct3D 12 but need to port it to macOS.

(From my experience, Vulkan is the hardest since it is more explicit than the other APIs. But it's the most cross-platform of the three.)

(There's also WebGPU but I don't have a lot of experience with it so can't comment. And OpenGL is popular but works slightly differently.)

Core versus Auxiliary
---------------------

I'll start out by saying that you can't make a 3D graphics app with just the graphics API. Each one makes the distinction between "this is how you tell the GPU what to do" and "here's how you integrate with the rest of the OS"; for lack of better terms, I'll call these "core" and "auxiliary" respectively.

In Direct3D 12, anything ``ID3D12*`` is core, but you use the auxiliary DXGI (``IDXGI*``) to discover adapters (GPUs).

In Metal, anything ``MTL*`` is core, but you use the auxiliary MetalKit (``MTK*``) to have a view to draw into.

In Vulkan, you use the auxiliary Window System Integartion (a.k.a WSI, ``*KHR``) to create surfaces and swapchains.

(Additionally, you need platform-specific APIs to create windows.)

Each API draws the line between "core" and "auxiliary" at different points. For example, Direct3D 12 puts adapters in the DXGI, but Vulkan puts physical devices in the core.

Device
------

The first thing you need is a device. This represents your app's use of the GPU.

Vulkan and Direct3D 12 require you to know up front which graphics card you want to use. Vulkan calls these physical devices; Direct3D 12 calls them adapters. In a desktop tower, there's likely only 1 graphics card. However, some computers have multiple! For example, I have a laptop with both an integrated and dedicated GPU; I may want to use the integrated for applications that play video, or the dedicated GPU for video games. You might also want to choose a software renderer in niche scenarios.

In Direct3D 12, you use DGXI to get the adapter, then call ``D3D12CreateDevice()``:

.. code-block:: c++

    // If you're new to COM, here's a primer: it's IPC that dates back to early versions of Windows (think 3.1 or 95).
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
        // Need DXGI to list adapters.
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
    struct DeviceAndQueue MakeDeviceWithQueue(
            VkPhysicalDevice physical_device,
            uint32_t queue_family_index)
    {
        VkDeviceQueueCreateInfo queue_create_info = /*...*/;
        // Tell Vulkan that we want 1 queue from the given queue family.
        queue_create_info.queueFamilyIndex = queue_family_index;
        queue_create_info.queueCount = 1;

        // Queues are created at the same time as the device.
        VkDevice device = VK_NULL_HANDLE;
        VkDeviceCreateInfo device_create_info = /*...*/;
        device_create_info.queueCreateInfoCount = 1;
        device_create_info.pQueueCreateInfos = &queue_create_info;
        vkCreateDevice(physical_device, &device_create_info, /*pAllocator=*/NULL, &device);

        // Since we created one queue for the given queue family, now we can retrieve it.
        VkQueue queue = VK_NULL_HANDLE;
        vkGetDeviceQueue(device, queue_family_index, /*queue_family_index=*/0, &queue);

        return {device, queue};
    }

Commands
--------

In order to tell the GPU what to do, you submit commands to the queue. Multiple commands are recorded or encoded into a single buffer for efficient submission.

In Direct3D 12, you make command lists from an allocator. You also need to create a pipeline first, which I'll describe in a later section.

.. code-block:: c++

    struct AllocatorAndCommandList {
        ComPtr<ID3D12CommandAllocator> command_allocator;
        ComPtr<ID3D12GraphicsCommandList> command_list;
    };

    // Graphics means drawing triangles. I'll talk more about graphics vs compute later.
    // list_type of D3D12_COMMAND_LIST_TYPE_DIRECT is common and likely what you want for simple apps.
    AllocatorAndCommandList MakeCommandList(
            ID3D12Device* device,
            D3D12_COMMAND_LIST_TYPE list_type,
            ID3D12PipelineState* pipeline_state)
    {
        ComPtr<ID3D12CommandAllocator> command_allocator;
        m_device->CreateCommandAllocator(list_type, IID_PPV_ARGS(&command_allocator));

        // See Direct3D docs for what nodeMask means
        ComPtr<ID3D12GraphicsCommandList> command_list;
        device->CreateCommandList(
                /*nodeMask=*/0,
                list_type,
                command_allocator,
                pipeline_state,
                IID_PPV_ARGS(&command_list));

        // Command lists are created in the recording state, but there is nothing
        // to record yet. Render() expects it to be closed.
        command_list->Close();

        return {command_allocator, command_list};
    }

    // This example reuses the same command list each frame. This is likely what you need to do.
    // There are not many instances where you can get away recording one thing and playing it
    // over and over again.
    void Render(
            ID3D12CommandQueue* queue,
            ID3DCommandAllocator* allocator,
            ID3D12GraphicsCommandList* list)
    {
        // Must only reset the allocator after the derived command lists have finished GPU execution.
        // See the Synchronization section for how to do this.
        allocator->Reset();

        // Must call reset before re-recording. This can be done immediately after ExecuteCommandLists().
        list->Reset(m_commandAllocator.Get(), m_pipelineState.Get()));

        // Run other command list methods like RSSetViewports, IASetVertexBuffers, DrawInstanced, ...

        list->Close();

        queue->ExecuteCommandLists(1, &list);
    }

In Metal, you create command buffers right from the queue with ``commandBuffer:``. You record commands with a command encoder. Then you commit the buffer.

.. code-block:: objective-c

    void Render(id<MTLCommandQueue> queue, MTKView* view) {
        id<MTLCommandBuffer> buffer = [queue commandBuffer];

        // Notice here, like Direct3D 12, we need to know a little about the pipeline.
        MTLRenderPassDescriptor *render_pass_descriptor = view.currentRenderPassDescriptor;
        id<MTLRenderCommandEncoder> encoder = [buffer renderCommandEncoderWithDescriptor:render_pass_descriptor];
        // Call encoder methods like setVertexBuffer, drawPrimitives, etc.
        [encoder endEncoding];
        [buffer commit];
    }

In Vulkan, you allocate command buffers from a pool then record a sequence of commands like "start render pass", "bind this vertex data", "draw some triangles". The buffer is then submitted to the queue.

.. code-block:: c

    struct CommandPoolAndBuffer {
        VkCommandPool pool;
        VkCommandBuffer buffer;
    }

    struct CommandPoolAndBuffer MakeCommandBuffer(VkDevice device, uint32_t queue_family_index) {
        // Make the pool from which we allocate command buffers.
        VkCommandPool pool = VK_NULL_HANDLE;
        VkCommandPoolCreateInfo pool_create_info = /*...*/;
        pool_create_info.queueFamilyIndex = queue_family_index;
        // Allow reuse of the same command buffer each Render()
        pool_create_info.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        vkCreateCommandPool(device, &pool_create_info, /*pAllocator=*/NULL, &pool);

        // Allocate a command buffer.
        VkCommandBuffer buffer = VK_NULL_HANDLE;
        VkCommandBufferAllocateInfo alloc_info = /*...*/;
        alloc_info.commandPool = command_pool;
        alloc_info.commandBufferCount = 1;
        // primary vs secodary
        vkAllocateCommandBuffers(device, &alloc_info, &buffer);

        return {pool, buffer};
    }

    void Render(VkQueue queue, VkCommandBuffer command_buffer) {
        // vkBeginCommandBuffer() implicitly resets the command buffer
        VkCommandBufferBeginInfo begin_info = /*...*/;
        vkBeginCommandBuffer(command_buffer, &begin_info);

        // Record commands with vkCmd*(), like: vkCmdBeginRendering(), vkCmdDraw(), etc
        // Unlike the other APIs, here is where we bind the pipeline.

        vkEndCommandBuffer(command_buffer);

        VkSubmitInfo submit_info = /*...*/;
        submit_info.commandBufferCount = 1;
        submit_info.pCommandBuffers = &command_buffer;
        vkQueueSubmit(queue, /*submitCount=*/1, &submit_info, /*fence=*/VK_NULL_HANDLE);
    }

Synchronization
---------------

You can kind of think of the GPU as a thread. And it's hungry! Once you submit work to it, it goes off and asynchronously starts chewing on the data. That leaves the CPU free to do... whatever it wants. But it won't be long until the GPU needs more. That means that you need some way to know when the GPU needs to be fed more data.

Direct3D 12 fences are similar to Metal sync events, which are similar to Vulkan has timeline semaphores.

Vulkan also has binary semaphores which control GPU dependencies between commands within a command buffer, and fences for more explicit CPU-GPU synchronization. You'll likely see these more in tutorials since timeline semaphores were an extension until Vulkan 1.2 (in 2020).

Graphics vs Compute
-------------------

Most of the time, you want to draw something like scene composed of triangles and textures. This is what the graphics pipeline is designed for.

Other times (sometimes alongside the graphis pipeline) you want to crunch a lot of numbers or do some other parallelizable math. This can be done with a compute pipeline.

Presentation
------------

Counterintuitively, you can use the graphics card without outputting to the screen. For example, you can draw a scene to memory then store it on disk as a PNG.

However, most of the time, you want to show the thing that you rendered to the user. This means you need some way to integrate with the operating system's windowing system so you can get a panel in a window and draw based on the monitor's refresh rate.

Vulkan calls this the Windowing System Integration (WSI). The setup is quite involved: after you create an instance, you need to create a surface (tied to a window) then a swapchain based on the surface. From the swapchain, you can get images to which you can draw. After you've drawn (by recording commands into a command buffer then submitting to your queue) you then need to explicitly present.
