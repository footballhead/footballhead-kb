===========
Diablo Beta
===========

While I started my reverse-engineering journey on the Diablo Beta (since it's so close to Devilution), I actually know very little about it...

----------
Installing
----------

#.  Install Beta, you can find the ISO at Diablo Evolution: https://diablo-evolution.net/index.php?pageid=files
#.  Install blankname's Beta Unlock Patch, you get it from the same place: https://diablo-evolution.net/index.php?pageid=files
#.  Download and extract my dungeon unlocker: https://drive.google.com/file/d/11wxrnx9t3IehOtz_RnRa3Kf9Z_iD3tAS/view
#.  Copy diablo.exe from blankname's Beta Unlock Patch into the dungeon unlocker folder
#.  Run patch.bat. This will pop open a terminal. If there are no errors then close the window. If vcdiff fails to run then please make sure you're running an up-to-date copy of Windows 10 and try again.
#.  Copy diablomod.exe into your install directory (default is ``C:\DIABLO``)
#.  Run ``diablomod.exe`` and enjoy!

This should work with both normal and nocd versions of blankname's patch.

-----------------------------
My patches (Dungeon Unlocker)
-----------------------------

Gitlab: https://gitlab.com/moralbacteria/diablo-beta-patches

This has some binary patches as well as instructions to fix other problems.

-----------------
My DDRAW.DLL Mods
-----------------

GitHub: https://github.com/footballhead/diablo-ddrawwrapper/tree/bnet_beta

.. warning:: This requires blankname's fix. Eventually, I intend to incorporate that fix but haven't gotten there yet. I am missing the necessary mods to ``STORM.DLL``/``diabloui.dll``/``standard.snp``.

This includes:

-   Dungeon Unlocker (access levels 6-8)
-   Poison Water fix
-   Catacomb warp fix
-   Fix bone spirit to use Elemental graphics
-   Cheats! Pressing Z gives a bunch of gold, all the spells, and a level up

------
Spells
------

Two things happen when you read a book:

#.  Increase slvl by 1
#.  Set the corresponding entry in the "spell has been learned" bitmap. Counterintuitively, this is a separate field from slvl.

A spell with spell level of 0 is uncastable, along with a spell that hasn't been learned. These are governed by separate memory addresses and structures:

-   Starting at ``0x0062D94A``, each spell gets 1 (signed) byte for spell level
-   Starting at ``0x0062D990`` is a bit map of which spells have been learned (1 is cast-able, 0 is not)

So to learn Firebolt (spell ID=0), you must:

-   Set ``0x0062D94A`` to ``1`` (or higher, but not too high because it's signed)
-   Take the value of ``0x0062D990``, bitwise OR the value with ``0x1``, then store it at the same address.

Since there are 36 spells, you'll need to modify 36 bytes starting at ``0x0062D94A``, and set 5 bytes (~36 bits) to ``0xFF``.

.. tip:: They left the MaxSpellsCheat function in so just call that?

Spell IDs
=========

0.  Firebolt
1.  Healing
2.  Lightning
3.  Flash
4.  Identify
5.  Fire Wall
6.  Town Portal
7.  Stone Curse
8.  Infravision
9.  Phasing
10. Mana Shield
11. Fireball
12. Guardian
13. Chain Lightning
14. Flame Wave
15. Doom Serpents
16. Blood Ritual
17. Nova
18. Invisibility
19. Inferno
20. Golem
21. Blood Boil
22. Teleport
23. Apocalypse
24. Etherealize
25. Item Repair
26. Staff Recharge
27. Trap Disarm
28. Elemental
29. Charged Bolt
30. Holy Bolt
31. Resurrection
32. Telekenesis
33. Heal Other
34. Blood Star
35. Bone Spirit

Spells That Don't Work
======================

The following spells don't work for one reason or another:

-   Mana shield: can still be killed even if you have mana
-   Guardian: casting has no effect
-   Doom Serpents: no effect
-   Blood Ritual: no effect
-   Invisibility: no effect
-   Golem: the game crashes if part of Nova touches it

    .. note:: NOTE TO SELF: This could be the "no two missiles on one space" crash that you fixed in pre-ablo...

-   Apocalypse: no effect
-   Etherealize: no effect
-   Bone Spirit: crashes on cast

    .. note:: NOTE TO SELF: This graphic is missing
