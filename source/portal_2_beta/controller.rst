==================
PS4/PS5 Controller
==================

.. note::

    Joystick, gamepad, and controller are all used interchangeably to refer to the same thing.
    
    (This likely comes from: DirectInput calls everything a "joystick"; XInput calls everything a "gamepad"; everyone colloquially refers to console input devices as "controllers")

.. note::

    Only ``joy 0`` (the first gamepad that you plug in) works. If you plug in another gamepad and it gets assigned ``joy 1`` then you're out of luck. If the problem is a bluetooth controller, then you can remove the controller in the bluetooth settings.

    TODO: Does Source have commands for this?

Without Steam Input, Source assumes that you're using an Xbox controller. However, you can use some console commands and convars to get a PS4/PS5 controller working.

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

.. note::

    The duck toggling behavior was taken from this reddit post: https://www.reddit.com/r/HalfLife/comments/pnr8ak/how_to_implement_the_option_to_toggle_crouch/

TODO:

-   How to swap HUD reticle? equivalent to ``cl_quickinfo_swap 1``?
-   Zoom?
-   Gamepad doesn't seem to work on the menu so can't unpause

--------------------
Commands and ConVars
--------------------

Portal 2 controls: https://strategywiki.org/wiki/Portal_2/Controls

.. tip::

    Launch hl2.exe with ``+developer 3`` to get more controller diagnostics

``joystick 1``
    Enable controllers

``+jlook``
    Enable looking up and down with the joystick controls.

``joy_advanced 1``
    Use "advanced" joystick input. This allows ``joy_advaxis(x|y|z|r|u|v)`` to be used to remap controller sticks. Without advanced controller input, the right control stick doesn't work.

``joyadvancedupdate``
    Apply current value of ``joy_advaxis(x|y|z|r|u|v)``. Required after changing those values.

``joy_advaxis(x|y|z|r|u|v) (0|1|2|3|4)``
    .. note::

        Requires ``joy_advanced 1`` to take effect.

    .. note::

        Must run ``joyadvancedupdate`` after changing to apply.

    Map an action to an axis.
    
    There are six axes but the PS4 controller only uses the first four. All axes:

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

``bind <key> <command>``
    Run ``<command>`` when ``key`` is pressed.

    All non-stick contoller inputs are treated as keys. A list of key mappings (`source <https://developer.valvesoftware.com/wiki/Bind>`_):

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
