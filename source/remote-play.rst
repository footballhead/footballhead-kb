============================
Remote Play (Game Streaming)
============================

Here's the situation:

#.  My gaming computer is on the main floor of my house ("host")
#.  My TV and couch are in the basement ("remote")

How do I play No Man's Sky, etc from the comfort of my couch?

Options:

#.  Sunshine with Moonlight (my current go-to)
#.  Nvidia GameStream with Moonlight
#.  Steam Link

----------------
My Current Setup
----------------

I use Sunshine.

-   My host uses an i7-8700K CPU with 16 GB of RAM and a RTX 4070 Ti GPU. It runs Windows, all my games, and Sunshine.
-   My remote uses a 3rd gen i3 (???) with 4 GB of RAM and a GTX 750 Ti CPU. It runs Windows and Moonlight (although I might switch to Linux in the future).
    -   PS4 controller attached to remote via USB. (I'm looking into Bluetooth adapters...)

My network looks something like this::

    modem --> router (Google WiFi) --> L2 switch --> all my wired computers (host and remote)
                        \
                         \--------> all my WiFi devices

Both my host and remote are wired. This required running a long ethernet cable between floors of my house...

-------
Options
-------

While I've settled on Sunshine, here are some notes for all the options that I tried.

Sunshine
========

This is the open source replacement for GameStream. This works `incredibly well` -- way better than GameStream -- for me. Like, shockingly well. I'm floored.

.. warning:: The installer reboots your PC without asking!

After reboot:

#.  Run Sunshine from the Start Menu. This will open the web UI when ready.
#.  Create a new user for the web UI. You use the web UI to change settings and enter PINs during pairing.
#.  Install and launch Moonlight on remote.

Couple things:

-   Turn off `Hardware-Accelerated GPU Scheduling` on the host.
-   Consider restoring your 3D settings in the Nvidia Control Panel (`3D Settings > Manage 3D settings > Global Settings > Restore`) on the host.

.. tip:: I was having no end of troubling with video jitter until I clicked `Restore` in the Nvidia Control Panel. I searched around a bit and it sounded like a frame rate mismatch but I couldn't figure it out! My monitor is 60hz, the game is 60hz, the stream is 60hz. I took a look at the logs though and it wanted 59.997 for some reason? Then I remembered that I futzed around the DSR for some reason; I think my meddling was causing Sunshine to get confused.

Adding New Games
----------------

Sunshine will only list a small selection of working games out of the box (like Steam). New games can be added manually through the web UI:

#.  Open the web UI.
#.  Click `Applications`.
#.  Click `Add New`.
#.  Fill out the form and click `Save`. I commonly fill out `Command` and `Run as administrator`.

Sunshine VS GameStream
----------------------

-   I noticed that GameStream will change the resolution of the host while Sunshine does not. I have no idea what impact this has but I can imagine that Sunshine will perform worse in this scenario (larger video + downsample)
-   Sunshine has lower latency than GameStream without compromising on visual quality.

GameStream
==========

This is Nvidia technology originally for the Nvidia Shield. However, Nvidia has killed this and Sunshine works better.

The Moonlight website is pretty good for explaining how to set it this up, but in a nutshell:

#.  Install GeForce Experience on host; enable GameStream.
#.  Install Moonlight on remote
#.  Launch Moonlight. There's a PIN authentication step that requires you to run between the two computers.

Adding New Games
----------------

By default, GeForce Experience will only list games that it detects as compatible. This includes Steam in Big Picture mode. If your game isn't in the list then there's a button in the GeForce Experience UI to add binaries.

Tips
----

Here are some gotchas or good-to-knows:

-   The host PC needs to have the primary monitor set as monitor 1. Otherwise I got a black screen. I don't know why, I just needed to do this.

    -   Sunshine had a note about making sure the capture GPU is the same as the GPU of the display running the game... this might have something to do with it.

-   Turn off VSYNC to reduce latency. Both in game and in the Moonlight settings.
-   While you can run Moonlight on a Google TV, I found that the latency was too noticable. I chalked this up to three things: the Google TV only supports WiFi, the controller (paired with the Google TV) used bluetooth, and I didn't mess with graphical settings like VYSNC.
-   Moonlight has a bunch of settings that you can use to control resolution, bitrate, VSYNC, etc.
-   Some games still require a mouse to get into the game (looking at you, Genshin Impact). If you have a PS4 controller, there is a setting to use the touchpad as mouse input
-   Moonlight will treat all controllers as Xbox controllers. I have PS4 controllers so this messes with stuff like the in-game tips and tutorials about button mapping.
-   The host and remote need to be visible to one another on the network.

Steam Link
==========

While this is the tech that got me throwing together my remote PC from spare parts, I haven't actually looked into this. Some people say they get better results from GameStream but I cannot say how they compare in my setup.
