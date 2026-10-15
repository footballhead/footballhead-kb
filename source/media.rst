====================
Media "Preservation"
====================

I had a family member pass away and got a bunch of media to dump/preserve:

-   Floppy disks
-   CD, DVD
-   USB Flash Drive
-   SD Card

------------
Floppy Disks
------------

I have a 2007-era Windows XP computer that has a 3-1/4" floppy drive.

The "easy" solution is `WinImage`_. However, you're out of luck if the disk fails to read... and I had many disks fail to read.

There are other more serious low level things like KryoFlux that I don't know anything about. TechTangents has done many streams related to KryoFlux; they have some notes `on their wiki <https://wiki.techtangents.net/wiki/Floppy_Disk_Imaging>`_.

---------------
USB Flash Drive
---------------

Just copy the files 4head

TODO: Data recovery (garbage but uncollected sectors)

-------
SD Card
-------

Kind of like USB flash drives except you need a fancy reader. I use a USB-C reader that I bought several years ago from a retail tech store (can't remember which one). I also have one that I bought from amazon.

------
CD/DVD
------

The "easy" solution is `ImgBurn`_

-   CD-RW/DVD-RW: ImgBurn will make a ``.ISO`` file, sometimes with ``.MDS`` file (typically for DVD video). The ``.ISO`` can be mounted via various means, or extracted with `7-Zip`_. I think the ``.MDS`` file is something about copy protection? idk doesn't seem to matter
-   Everything else: ImgBurn will create a ``.BIN`` and ``.CUE`` file pair. The ``.BIN`` file is the binary data. The ``.CUE`` file is text data saying where tracks start and stop. Annoyingly, there are very few programs which can mount bin/cue files... I'm trying out `BinChunker`_ aka ``bchunk`` in WSL.

I've had one bad disk: it was DVD video that stopped reading tracks half-way through. VLC will play it up to the bad track. DVD decrypter and ImgBurn error out. I think DVD Decrypter will let me read the first few good tracks. I haven't tried to clean the CD, nor have I tried making a binary dump of the disk (if that's even possible).

CDs are a bit of a rabbit hole. There are actually many kinds data that can be stored on CDs that need to be treated separately:

-   Audio aka CD-DA aka `Red Book`_: think music CDs from HMV. The oldest kind of CD.
-   Data aka CD-ROM aka `Yellow Book`_: think computer software on disk, or disks you burn yourself (sometimes called `ISO9660`_)
-   Multisession aka `Orange Book`_: audio and data on one disk. This was common for old PC games shipped on CD like Age of Empires. Also used for "rewritable disks" via a form of overlay FS.
-   `Video CD`_ aka CD-ROM XA (an extension of the Yellow Book): TODO

DVDs are also `complicated <https://en.wikipedia.org/wiki/DVD#Specifications>`_ but--in practice--I've only come across two kinds:

-   `DVD Video`_: A movie. You know you have one of these since it has a folder called ``VIDEO_TS`` (video title sets) and there are a bunch of ``.VOB`` (video object) files.
-   Data with ISO9660. Looks like any other file system

DVD Video
=========

Non-copy-protected discs are easy to rip to ``.ISO`` with ImgBurn then extract with 7-Zip. They can be played by pointing VLC at the ``VIDEO_TS`` folder or opening ``VIDEO_TS.IFO``.

Each ``.VOB`` contains video data. You can demux each track using `PgcDemux`_ (PGC is short for Program Chain, a core part of the ``.IFO`` file) to retrieve the MPEG2 video as a ``.MV2`` file and AC3 audo as a ``.AC3`` file. You can then mux these into a more modern container like ``.MVK`` with `MKVToolnix`_. I personally find that the individual ``.MKV`` videos extracted this way are easier to store, sort, and play compared to the ``.ISO`` itself. The only "downside" is that you lose the menus (which are typically bad for home videos anyway).

PgcDemux
--------

`PgcDemux`_ is a Windows program for demuxing DVD video titles into component video and audio files. Works as a GUI by default but offers CLI support. From ``ReadmePcgDemux.txt`` (included in source)::

    PgcDemux [option1] [option2] ... [option12] <ifo_input_file> <destination_folder>
    option1: [-pgc, <pgcnumber>].      Selects the PGC number (from 1 to nPGCs). Default 1
    option2: [-ang, <angnumber>].      Selects the Angle number (from 1 to n). Default 1
    option3: [-vid, <vobid>].          Selects the Angle number (from 1 to n). Default 1
    option4: [-cid, <vobid> <cellid>]. Selects a cell vobid (from 1 to n). Default 1
    option5: {-m2v, -nom2v}. Extracts/No extracts video file. Default NO
    option6: {-aud, -noaud}. Extracts/No extracts audio streams. Default YES
    option7: {-sub, -nosub}. Extracts/No extracts subs streams. Default YES
    option8: {-vob, -novob}. Generates a single PGC VOB. Default NO
    option9: {-customvob <flags>}. Generates a custom VOB file. Flags:
            b: split VOB: one file per vob_id
            n: write nav packs
            v: write video packs
            a: write audio packs
            s: write subs packs
            i: only first Iframe
            l: patch LBA number
    option10:{-cellt, -nocellt}. Generates a Celltimes.txt file. Only in PGC/VID mode. Default YES
    option11:{-log, -nolog}. Generates a log file. Default YES
    option12:{-menu, -title}. Domain. Default Title (except if filename is VIDEO_TS.IFO)

It won't find any video tracks if you don't actually open a video file. E.g. there are no video tracks in ``VIDEO_TS.IFO``; you likely want to start at ``VTS_01_0.IFO``. Make sure you select:

-   Mode: by VOB ID
-   VOB Id Selection: Titles
-   Options:

    -   Check Demux video stream
    -   Check Demux all audio streams
    -   The others you can check or uncheck as you like

Use the combobox under the VOB Id Selection group to make sure that you are dumping all videos!

You'll have to manually open each ``VTS_*.IFO`` and manually dump each video track.

.. note::

    Source is available from the developer's website: https://download.videohelp.com/jsoto/dvdtools.htm

TODO automate this

Slideshows
==========

Many of the DVD videos are just slideshows. It would be easier to manage if they were decomposed back into individual images. You could manually screen grab each new frame. Or you can try to automate by dumping the I-frames then discarding any duplicates.

To dump I-frames with FFMPEG:

.. code-block:: shell

    ffmpeg -skip_frame nokey -i mux.mkv -vsync vfr frame_%04d.png

.. note::

    Lightroom does a bad job at identifying duplicates so that's not an option...

TODO: discard duplicates and images mid-transition

Backups
-------

I upload everything to B2 Cold Storage using the B2 CLI.

.. _WinImage: https://www.winimage.com/winimage.htm
.. _PgcDemux: https://download.videohelp.com/jsoto/dvdtools.htm
.. _Red Book: https://en.wikipedia.org/wiki/Rainbow_Books#Red_Book_(1980)
.. _Yellow Book: https://en.wikipedia.org/wiki/Rainbow_Books#Yellow_Book_(1983)
.. _Orange Book: https://en.wikipedia.org/wiki/Rainbow_Books#Orange_Book_(1990)
.. _ISO9660: https://en.wikipedia.org/wiki/ISO_9660
.. _Video CD: https://en.wikipedia.org/wiki/Video_CD
.. _ImgBurn: https://www.imgburn.com/
.. _7-Zip: https://www.7-zip.org
.. _BinChunker: http://he.fi/bchunk/
.. _DVD Video: https://en.wikipedia.org/wiki/DVD-Video
.. _MKVToolNix: https://mkvtoolnix.download/index.html
