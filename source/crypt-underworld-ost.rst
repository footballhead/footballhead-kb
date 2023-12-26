====================
Crypt Underworld OST
====================

`Crypt Underworld`_ is an experimental FPS video game by Lilith Zone with music by `ESPer99`_. While `ESPer99's Soundcloud <https://soundcloud.com/esper99>`_ features some music (in addition to alternate cuts), it doesn't feature all the music in the game.

Outside of a few select tracks, most of the ambience is constructed by layering a variety of slowed-down and pitch-shifted stems.

-----------------------------------
Extracting and Reconstructing Music
-----------------------------------

The game is made in Unity.

First, I used `AssetRipper`_ to extract all assets from the final game.

Second, I opened the scenes to determine which sounds it plays and how. The ``.scene`` files are text so I used Notepad to interpret them. I searched for ``AudioSource`` objects. This contains the ``m_audioClip`` field which specifies the ``guid`` of the sound to play. All GUIDs are stored in the ``*.meta`` files. Don't be thrown off by the number of ``AudioSource`` objects since every NPC that plays a sound also has one.

------------
Ghost Buffet
------------

The base stem is ``fallingfalling.wav``. There are two layers:

#. 50% speed with Unity's "Psychotic" reverb preset
#. 25% speed with Unity's "Psychotic" reverb preset

.. _Crypt Underworld: https://lilithzone.itch.io/crypt-underworld
.. _ESPer99: https://www.esper99.org/
.. _AssetRipper: https://github.com/AssetRipper/AssetRipper
