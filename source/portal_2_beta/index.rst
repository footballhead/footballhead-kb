=============
Portal 2 Beta
=============

Early Portal 2 versions were being distributed (???) via non-public AppID 841 and AppID 852 (likely to test multiplayer). This only came to light after the Steam2 Teraleak.

------
Builds
------

.. toctree::
    :maxdepth: 2

    3916.rst
    4107.rst
    4149.rst
    4275.rst
    4314.rst
    4339.rst
    4364.rst

------------
General Info
------------

.. warning::
    
    These are old build of Source with unpatched vulnerabities. Only play multiplayer with people that you trust.

.. tip::

    On Windows 11, Smart App Control will block launching any of the ``.bat`` files. It may also interfere with loading any of the ``.dll`` files. To make it work, turn off Smart App Control in Windows settings. Beware that this effectively disables virus scanning!


App ID 852: https://femtendo.github.io/steam2-catalog/#depot-852

-   v0: :doc:`3916`
-   v1: :doc:`4149`
-   v2: :doc:`4275`
-   v3: :doc:`4314`
-   v4: :doc:`4364`
-   v5: :doc:`4364`

App ID 841: https://femtendo.github.io/steam2-catalog/#depot-841

-   v0: :doc:`4107`
-   v1: ?
-   v2: :doc:`4339`

---------------
Useful Commands
---------------

``sv_cheats (0|1)``
    Default: 0. Set to 1 to enable cheats

``noclip``
    (Requires ``sv_cheats 1``) Disable collision and gravity

``bind <key> <command>``
    Perform ``<command>`` when ``<key>`` is pressed.

    You can also have two or more commands run at the same time with the ``;``. For example::

        bind n "sv_cheats 1;noclip"

``mat_colcorrection_disableentities 1``
    Disable color correction (fix trippy color correction bug)

``give <weapon>``
    Give the player ``<weapon>``. Two useful ones:

    #.  ``weapon_portalgun``: The (blue) portal gun (see ``upgrade_portalgun``)
    #.  ``weapon_paintgun``: The paint gun

``upgrade_portalgun``
    Allow the portal gun to shoot both blue (``+attack``) and orange (``+attack2``) portals

``cl_disable_survey_panel 1``
    Disable end of level surveys

``+slowtime``
    Toggle slow time.

-------
Surveys
-------

In the repack, surveys should be disabled by default. However, if deleted your ``config.cfg`` (like I did), then you can disable them with::

    cl_disable_survey_panel 1

---------
Paint gun
---------

.. note::

    In some builds, the paint gun is not bound to keys by default. Suggested keybinds (commented out in ``portal2/cfg/config_default.cfg``)::

        bind MWHEELUP prevpaint
        bind MWHEELDOWN nextpaint
        bind 1 "changepaintto bounce"
        bind 2 "changepaintto speed"
        bind 3 "changepaintto stick"
        bind f +alt1

    Put these in portal2/cfg/joystick.cfg

Basic usage:

-   Left click (``+attack``): fire selected paint type
-   Right click (``+attack2``): fire cleanup paint

Paint types (likely taken from Tag: The Power of Paint):

-   Green: bounce (blue gel in retail)
-   Red: speed (orange gel in retail)
-   Blue: stick (cut from retail)

Console commands:

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

-------
Gamepad
-------

.. note::

    Only ``joy 0`` (the first gamepad that you plug in) works. If you plug in another gamepad and it gets assigned ``joy 1`` then you're out of luck. If the problem is a bluetooth controller, then you can remove the controller in the bluetooth settings.

Without Steam Input, Source assumes that you're using an Xbox controller. However, there are some convars that can be set for the PS4/PS5 controller.

This is the config that I use:

.. code-block:: text

    // Use joystick input
    joystick 1

    // Enable the ability to look up/down
    +jlook

    // Use advanced joystick mapping so we can map the axes
    joy_advanced 1

    // Left stick horizontal axis moves left/right
    joy_advaxisx 3

    // Left stick vertical axis moves forward/back
    joy_advaxisy 1

    // Right stick horizontal axis looks left/right 
    joy_advaxisz 4

    // Right stick vertical axis looks up/down
    joy_advaxisr 2

    // Square picks up/uses
    bind JOY1 +use

    // X jumps
    bind JOY2 +jump

    // Circle crouches. There's no crouch toggle but we can make our own by
    // redefining an alias.
    bind JOY3 crouch_toggle
    alias crouch_toggle crouch_on
    alias crouch_on "alias crouch_toggle crouch_off; +duck; echo crouched"
    alias crouch_off "alias crouch_toggle crouch_on; -duck; echo uncrouched"

    // Triangle is slow time. Unlike duck, +slowtime acts as a toggle
    bind JOY4 +slowtime

    // L1 swaps between portal gun and paint gun
    bind JOY5 +alt1

    // R1 changes paint color
    bind JOY6 nextpaint

    // L2 fires an orange portal
    bind JOY7 +attack2

    // R2 fires a blue portal
    bind JOY8 +attack

    // Options shows in-game menu (and pauses)
    // NOTE: Gamepad doesn't work on the gameui so can't unpause
    bind JOY10 toggle_gameui
    alias toggle_gameui show_gameui
    alias show_gameui "gameui_activate; alias toggle_gameui hide_gameui"
    alias hide_gameui "gameui_hide; alias toggle_gameui show_gameui"

    // D-Pad Up gives you the paint gun
    bind POV_UP "sv_cheats 1;give weapon_paintgun;giveallpaintpowers"

    // Apply all advanced joystick settings
    joyadvancedupdate

Save it to ``portal2/cfg/joystick.cfg``.

.. note::

    ``joystick.cfg`` is referenced by ``valve.rc`` so will be loaded on game startup. We need to do this since we need to ensure that the aliases are defined.

    Another option would be to copy ``portal/cfg/valve.rc`` to ``portal2/cfg/valve.rc`` and add the commands there.

TODO:

-   How to swap HUD reticle? equivalent to ``cl_quickinfo_swap 1``?
-   Zoom?
-   Gamepad doesn't seem to work on the menu so can't unpause

Explanation
===========

In this section, I will explain how I arrived at these settings.

Portal 2 controls: https://strategywiki.org/wiki/Portal_2/Controls

.. tip::

    Launch hl2.exe with ``+developer 3`` to get more controller diagnostics

First, run this to enable gamepads::

    joystick 1

Advanced settings
=================

Source has two controller schemes: non-advanced and advanced. The right control stick doesn't work if non-advanced is used. Thus, we need to enable advanced settings::

    joy_advanced 1

Any time an advanced setting is changed, need to run::

    joyadvancedupdate

Stick configuration
===================

In order to be able to look up and down, need to run::

    +jlook

Source maps one of 6 stick axes to an action. Of the 6, the PS4 controller only uses the first The gist is that you bind a stick axis to an action. Possible stick directions:

-   ``joy_advaxisx``: PS4 left stick, horizontal axis
-   ``joy_advaxisy``: PS4 left stick, vertical axis
-   ``joy_advaxisz``: PS4 left stick, horizontal acis
-   ``joy_advaxisr``: PS4 right stick, vertical axis
-   ``joy_advaxisu``: ??? Always held
-   ``joy_advaxisv``: ??? Always held

Possible actions:

-   ``0``: "unmapped"
-   ``1``: "forward (absolute)": move forward or back
-   ``2``: "pitch (absolute)": look up or down (requires ``+jlook``)
-   ``3``: "strafe (absolute)": move left or right
-   ``4``: "yaw (absolute)": look left or right

.. warning::

    Anything outside 0-4 (e.g. 5) crashes the game

Everything else
===============

Everything that isn't a stick is bound as if it were a key. A list of key mappings from experimentation (and confirmed by https://developer.valvesoftware.com/wiki/Bind):

-   Square is ``JOY1``
-   X is ``JOY2``
-   Circle is ``JOY3``
-   Triangle is ``JOY4``
-   L1 is ``JOY5``
-   R1 is ``JOY6``
-   L2 is ``JOY7``
-   R2 is ``JOY8``
-   Share is ``JOY9``
-   Options is ``JOY10``
-   L3 is ``JOY11``
-   R3 is ``JOY12``
-   Playstation button is ``JOY13``
-   Touchpad is ``JOY14``
-   D-Pad Up is ``POV_UP``
-   D-Pad Down is ``POV_DOWN``
-   D-Pad Left is ``POV_LEFT``
-   D-Pad Right is ``POV_RIGHT``

.. note::

    The duck toggling behavior was taken from this reddit post: https://www.reddit.com/r/HalfLife/comments/pnr8ak/how_to_implement_the_option_to_toggle_crouch/
