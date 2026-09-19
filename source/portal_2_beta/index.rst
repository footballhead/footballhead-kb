=============
Portal 2 Beta
=============

Early Portal 2 versions were being distributed (???) via non-public AppID 841 and AppID 852 (likely to test multiplayer). This only came to light after the Steam2 Teraleak.

------
Builds
------

.. toctree::
    :maxdepth: 2

    paintgun.rst
    controller.rst
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
