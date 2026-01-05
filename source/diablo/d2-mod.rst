==============
Diablo II Mods
==============

Some D2 mods that I like.

-----
PlugY
-----

Link: http://plugy.free.fr/en/index.html

This is a great "quality of life" singleplayer mod:

-   Infinite stash spash
-   Shared stash
-   Reset skills/stats
-   Ladder runewords
-   Ubers

Mod makers tend to make their mods PlugY compatible (or otherwise intentionally incompatible); it's a big deal.

I've done a breakdown of their source in :doc:`plugy`

--------------------
Sven's Glide Wrapper
--------------------

Link: http://www.svenswrapper.de/english/

Basically required on modern Windows. Translates the glide3d mode into OpenGL. IMO results in better colors and performance on modern systems compared to DirectDraw.

Configuration is done through a custom GUI.

In 1.14, need to launch Diablo 2 with ``-3dfx``. Otherwise, run Video Test and choose Glide.

----
d2dx
----

Link: 

This is kinda like a (better?) Sven's Glide Wrapper that includes SGD2FreeRes. Improvements over Sven's Glide Wrapper:

-   Higher FPS, especially felt with the smoothness of the mouse cursor
-   Widescreen thanks to SGD2FreeRes

Configuration is done via ``d2dx.cfg``

In 1.14, need to launch Diablo 2 with ``-3dfx``. Otherwise, run Video Test and choose Glide.

.. note:: If running with PlugY then also need to copy ``glide3x.dll`` into the PlugY folder. Same goes for the config file. The Plugy shortcut will need ``-3dfx``

.. note:: Toggle windowed/fullscreen with Alt+Enter

-----------
SGD2FreeRes
-----------

Link: https://github.com/mir-diablo-ii-tools/SlashGaming-Diablo-II-Free-Resolution

Adds widescreen support. Not standalone, needs something like d2dx to load it.

----------
d2modmaker
----------

Source: https://github.com/tlentz/d2modmaker

This is a combination:

-   item randomizer (random affix/suffix on unique/sets, etc)
-   Sh*tfest (IncreaseMonsterDensity)

This *kinda* (not really) replaces the randomizer and Sh*tfest links below.

Installing:

-   Copy ``data`` folder into ``C:\Program Files (x86)\Diablo II\Mod Plugy``
-   Create a shortcut to ``PlugY.exe``
-   Modify that shortcut; add ``-direct -txt`` to Target

Generator vs Randomizer
=======================

These are mutally exclusive:

-   Generator will make new uniques, sets, and runewords. This is dynamic: e.g. Rixot's Keen will always be different.
-   Randomizer will shuffle existing properties. This is static: e.g. Rixot's Keen will always be the same.

--------
Sh*tfest
--------

-   Link: https://d2mods.info/forum/viewtopic.php?f=5&t=66548 (DOWNLOAD LINK IS DEAD)
-   Archived link: https://www.dropbox.com/s/kc9i671ozpwfuxs/SHIFTFEST%20FOR%20D2SE.zip?dl=1 (just copy data/ into D2 folder)

The tl;dr is that areas are PACKED with monsters. It's like Vampire Survivors before Vampire Survivors.

    The Sh*tfest mod is literally just the Monster Density set to 10% chance to spawn a monster per tile and up to 99 boss/champion packs. In addition, some areas that previously could spawn enemies really close to you now spawn a bit further away to give you a fair chance. All monster types will now spawn as well, so there is no reason to restart the game if you find souls. You're putting up with them no matter what.

    \- https://d2mods.info/forum/viewtopic.php?f=5&t=66548

------------------
D2 Item Randomizer
------------------

Link: https://www.twitch.tv/tpscrollbot/about

Flagged as a virus but used by several streamers no problem. I have some theories about why... (I think it's C# .NET that tries to access files outside the current working dir... which probably freaks out Windows Defender. But I haven't disassmbled to find out)

--------
MedianXL
--------

Almost a total conversion at this point. It looks like you're playing D2 but you're not. It's very fast-paced and flashy.

--------------
Path of Diablo
--------------

Link: https://pathofdiablo.com/

D2 with some quality of life improvements but also a buttload of gameplay changes. Plays the same... but different!

----
D2SE
----

Old and unsupported. Wouldn't recommend (though some people still do???)
