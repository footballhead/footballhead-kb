==========
Steam Deck
==========

I bought a Steam Deck OLED so I can play gachas while I'm away on vacation.

----------------
General Thoughts
----------------

Why not Lenovo Legion Go or Asus ROG Ally
=========================================

- Steam Deck seems to be the most stable and reliable. Apparently there are software and hardware issues with the others.
- That does mean sacrificing on-paper tech specs considering the competition offers higher resolutions and display refresh rates. However, I'm not looking for a desktop replacement; this is an airport fidget. The increase resolution and refresh rate would eat into battery life for honestly not a whole lot of gain. 
- I also sacrifice Windows (yes you can install Windows but it doesn't seem to work great) but I'm comfortable with Linux and Proton seems to work well. I prefer an OS that I can hack in a pinch...

Unorganized thoughts
====================

- It defaults into "Native Big Picture" but can be swapped into Desktop Mode. This works with USB-C hubs! Having a keyboard and mouse really helps getting non-Steam games working.
- Desktop Mode is Arch running KDE. Time to play pacman. I'm a GNOME guy but KDE is very polished, powerful, and approachable.
- I call it "Native Big Picture" because it offers more than Desktop Mode running Big Picture. Primarily, the Steam Deck overlay only works in "Native Big Picture" but not Desktop Mode running Big Picture. This seems important for optimizing battery life. Also, the input remapping only seems to work in "Native Big Picture".
- "Native Big Picture" does run a basic window manager, it just lacks decoration and shows up centered.
- I got the 90hz model. I notice it occasionally but 60hz is fine for me. Anything above that is gravy. I worry about the battery life that this eats up...

Notes for getting games
=======================

- Want Minecraft? Use PrismLauncher. This makes it slightly easier to add as a non-steam game. I still had to convert their .desktop to .sh so it can be added as a non-Steam game...
- Use Epic? Install Heroic from the app store, then add them to Steam as non-steam Games.
- Play Genshin? Sounds like HoyoPlay works but I used Heroic. I think that I needed to change the install drive from Z: to C:. Then I added the Unity binary as the non-Steam game. Then, in Steam, I needed to turn on compatibility with Proton. This game does not work in Desktop Mode since input remapping doesn't work in that mode. You'll want to log in with a physical mouse and keyboard.
- The above applies for ZZZ as well.
- Palia? I installed though Heroic then added PaliaClient.exe as a non-Steam game. It was complaining about the C++ Runtime but Reddit to the rescue. I installed protontricks and used that to get vcrun2022. I found this easiest to log in when not docked, otherwise the game resolution got really messed up and input didn't work well. You need to log in every time so I recommend having a password manager like 1password (which you can install from the app store)

Current annoyances
==================

- While it basically runs any Windows game, every non-Steam game I've downloaded requires non-zero time investment to add it to Steam. Typically I need to drop into Desktop Mode, install the game, find the binary on disk, launch it once or twice to make sure it works, maybe write a wrapper script, then go into Steam and hope it can be added.  Then hope Proton works. I've had trouble importing .desktop files (which is annoying...) but those are trivial to convert into a .sh
- You need to keep the screen on to download games. Burn-in isn't a problem with the OLED under normal use though so this is more a LOL than anything else.
- Steam+X is the soft keyboard. This is not easy to discover and is necessary for Desktop Mode. It also doesn't work as well as a physical keyboard (problems with text field focus, etc).

--------
Hardware
--------

The Steam Deck ships with a 45W charger. For comparison, my MacBook Air M1 shipped with a 30W charger and my Pixel phone shipped with a 15W charger.

If you don't use a 45W charger, the LED will be solid yellow/orange while charging. Id you do use a 45W charger, the LED will be a solid white while charging. When charged, the LED is solid green.

------
Heroic
------

This is a open-source Epic Games launcher for Linux. It uses Proton/Wine to run games.

How to add games to steam:

#. Open Heroic
#. Navigate to your library
#. Find the game you want to add to Steam and open the Details. You can either click the picture of the game or right click > Details. This should open a screen with a larger version of the art.
#. Click the 3 dots in the top-right. Select Add to Steam
#. Restart Steam

------------
Programming
------------

I'd recommend getting a USB-C dock with a mouse and keyboard

The `Steam Deck FAQ <https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C>`_ is an enlightening read. Some highlights:

- flatpak via Discover Software Center is the recommended way to install apps (i.e. not pacman)
- Part of the OS is in a read-only partition. I guess Valve wants to control system software to ensure smooth updates (understandable). This has some ramificiations:
    - Need to ``sudo steamos-readonly disable`` to get ``pacman`` working
    - Anything installed via pacman risks getting blown away by updates!
- Can't use ``sudo`` out of the box, need to ``passwd`` first.

Other things to know:

- SteamOS runs Arch Linux.

So docker might be out of the question but that doesn't stop you from using `chroot <https://www.reddit.com/r/SteamDeck/comments/y7rjfz/steamos_and_arch_linux_chroot/>`_ instead!

References:

- Reddit post claiming chroot works: https://www.reddit.com/r/SteamDeck/comments/y7rjfz/steamos_and_arch_linux_chroot/
- Gist about installing pacman in a chroot: https://gist.github.com/theodric/cb60ac3d0e1232450435007e09ffefcc
- pacstrap (pacman bootstrap) docs: https://wiki.archlinux.org/title/Pacstrap
- More notes about chroot: https://steamcommunity.com/sharedfiles/filedetails/?id=2877026756
- Notes about installing docker: https://neveriand.github.io/articles/new/new-02-install-docker-on-a-steam-deck.html


