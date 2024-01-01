============================
Remote Play (Game Streaming)
============================

Here's the situation:

#. My gaming computer is on the main floor of my house ("host")
#. My TV and couch are in the basement ("remote")

How do I play No Man's Sky, etc from the comfort of my couch?

Options:

#. Steam Link
#. Nvidia GameStream, or Moonlight/Sunlight

----------
GameStream
----------

This is Nvidia technology originally for the Nvidia Shield. However, there are open source implementations now in Sunshine (for host) and Moonlight (for remote).

The website is pretty good for explaining how to set it up, but in a nutshell:

#. Install GeForce Experience on host
#. Install Moonlight on remote
#. Launch Moonlight. There's a PIN authentication step that requires you to run between the two computers.

My Setup
========

- My host is an i7-8700k, 16 GB RAM, RTX 4070 Ti running Windows, Steam, GeForce Experience
- My remote is a 3rd gen (???) i3, 4 GB RAM, GTX 750 Ti running Windows, Moonlight
- PS4 controller attached to remote via USB. (I'm looking into Bluetooth adapters...)

My network looks something like this::

    modem (ISP whatever) --> router (Google WiFi) --> layer 2 switch --> the rest of my wired computers (host and remote)

Both my host and remote are wired (which meant running a long ethernet cable between floors of my house).

Tips
====

Here are some gotchas or good-to-knows:

- The host PC needs to have the primary monitor set as monitor 1. Otherwise I got a black screen. I don't know why, I just needed to do this.
- Turn off VSYNC to reduce latency. Both in game and in the Moonlight settings.
- While you can run Moonlight on a Google TV, I found that the latency was too noticable. I chalked this up to three things: the Google TV only supports WiFi, the controller (paired with the Google TV) used bluetooth, and I didn't mess with graphical settings like VYSNC.
- Moonlight has a bunch of settings that you can use to control resolution, bitrate, VSYNC, etc.
- Some games still require a mouse to get into the game (looking at you, Genshin Impact). If you have a PS4 controller, there is a setting to use the touchpad as mouse input
- Moonlight will treat all controllers as Xbox controllers. I have PS4 controllers so this messes with stuff like the in-game tips and tutorials about button mapping.
- The host and remote need to be visible to one another on the network. I found that I needed to do something like this for wired and WiFi connections to see each otehr: ``modem (ISP whatever) --> router (Google WiFi) --> layer 2 switch --> the rest of my wired computers (host and remote)``

Sunshine
========

I heard that using Sunshine instead of GeForce Experience can reduce latency but haven't looked into this.

----------
Steam Link
----------

While this is the tech that got me throwing together my remote PC from spare parts, I haven't actually looked into this. Some people say they get better results from GameStream but I cannot say how they compare in my setup.
