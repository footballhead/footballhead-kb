=========
Paint gun
=========

Early Portal builds had a weapon called ``weapon_paintgun`` which allowed the player to shoot specific gels.

.. note::

    "Gel" and "paint" are used interchangeably in this document to refer to the same thing.

--------
Keybinds
--------

In some builds, the paint gun does not have keybinds. Suggested keybinds::

    bind MWHEELUP prevpaint
    bind MWHEELDOWN nextpaint
    bind 1 "changepaintto bounce"
    bind 2 "changepaintto speed"
    bind 3 "changepaintto stick"
    bind f +alt1

Put these in ``portal2/cfg/joystick.cfg``

TODO: Some builds have conversion gel

------
Inputs
------

Basic usage:

-   Left click (``+attack``): fire a stream of the selected gel
-   Right click (``+attack2``): fire cleanup gel
-   ``1``/``2``/``3``: change selected gel color (requires ``giveallpaintpowers``)
-   ``f``: Switch between portal gun and paint gun

TODO: Some builds have conversion gel

---------
Gel types
---------

Each gel has an internal name:

-   Repulsion: "bounce"
-   Propulsion: "speed"
-   Adhesion: "stick"
-   Conversion: ???

Colors
======

Gels first appears in :doc:`4107` with these colors (likely taken from Tag: The Power of Paint):

-   Green: bounce
-   Red: speed
-   Blue: stick

In subsequent builds, gels use the same colors as retail:

-   Blue: bounce
-   Orange: speed
-   Purple: stick
-   White: conversion gel

TODO: Some builds have conversion gel

Adhesion ("stick")
==================

This cut gel lets you walk on walls. This can be pretty buggy depending on the build: graphical glitches; mouse look works OK but joystick looking is practically unusable.

--------
Commands
--------

``give weapon_paintgun``
    Get the paint gun

``giveallpaintpowers``
    Unlock all paint types

``prevpaint``
    Select previous paint type

``nextpaint``
    Select next paint type

``changepaintto (bounce|speed|stick)``
    Select a specific paint type

``+alt1``
    Switch between portal gun and paint gun

--------
Crashing
--------

In some builds (like :doc:`4149`), using too much of the gels will cause the game to crash on level transition. This is particularly egregious for ``sp_paint_speed_racer``.

Try to limit the amount of gels used. For maps where this isn't possible (e.g. ``sp_paint_speed_racer``), just be fast :)

----------
paintinmap
----------

Starting in :doc:`4149`, gels can only be used in a map when the ``paintinmap`` worldspawn entity key is set to ``1``. This is read-only; ``ent_keyvalue 0 paintinmap 1`` doesn't do anything. AFAICT, changing requires decompiling the map, altering the value, then recompiling the map

TODO: Check if a BSP binary modification is possible
