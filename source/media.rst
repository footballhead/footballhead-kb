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

Dumping the CD is the easy part: use `ImgBurn`_

-   For CD-RW/DVD-RW: ImgBurn will make a ``.ISO`` file, sometimes with ``.MDS`` file (typically for DVD video). The ``.ISO`` can be mounted via various means, or extracted with `7-Zip`_; `Dietrich at al`_ refer to this as a "User Data" disk image: it's size is a multiple of 2048. I think the ``.MDS`` file is something about copy protection? idk doesn't seem to matter
-   For everything else: ImgBurn will create a ``.BIN`` and ``.CUE`` file pair. The ``.BIN`` file is the binary data; `Dietrich at al`_ refer to this as as "RAW" disk image: it contains error correction and the size is a multiple of 2352 bytes. The ``.CUE`` file is the "`cue sheet`_": text data saying where tracks start and stop. Annoyingly, there are very few programs which can mount RAW disk images files, let alone handle multi-session RAW disk images...

I've had one bad disk: it was DVD video that stopped reading titles half-way through. VLC will play it up to the bad titles. DVD decrypter and ImgBurn error out. I think DVD Decrypter will let me read the first few good titles. I haven't tried to clean the CD, nor have I tried making a binary dump of the disk (if that's even possible).

Optical media is a bit of a rabbit hole. Apart from the kinds of disk (CD-R, CD-RW, DVD+R, ...) There are actually many kinds data that can be stored on CDs that need to be treated separately:

-   Audio aka CD-DA aka `Red Book`_: think music CDs from HMV. The oldest kind of CD.
-   Data aka CD-ROM aka `Yellow Book`_: think computer software on disk, or disks you burn yourself (sometimes called `ISO9660`_)
-   Multisession aka `Orange Book`_: audio and data on one disk. This was common for old PC games shipped on CD like Age of Empires. Also used for "rewritable disks" via a form of overlay FS.
-   `Video CD`_ aka CD-ROM XA (an extension of the Yellow Book): TODO

DVDs are also `complicated <https://en.wikipedia.org/wiki/DVD#Specifications>`_ but--in practice--I've only come across two kinds:

-   `DVD Video`_: A movie. You know you have one of these since it has a folder called ``VIDEO_TS`` (video title sets) and there are a bunch of ``.VOB`` (video object) files.
-   Data with ISO9660. Looks like any other file system

.. warning::

    I tried ``dd`` from Linux but it didn't always produce usable ``.ISO`` files. In retrospect, it was probably an issue with multisession disks...

bchunk
======

`BinChunker`_ aka ``bchunk`` promises to convert RAW disk images into ``.ISO``. It kinda works on multi-session RAW disk images (see `Dietrich at al`_ or keep reading)

.. warning::

    `Linux Command Library <https://linuxcommandlibrary.com/man/bchunk>`_ notes several caveats that I can't find elsewhere:

        BIN files must match the layout described in the CUE sheet exactly. Multi-session discs may not convert correctly. Some protected or non-standard disc images may fail to convert.

Multi-session
=============

Seems like this is a known pain in the ass.

For RAW images (bin/cue), `Dietrich at al`_ outlines:

#.  Extracting session offsets

#.  Extracting files from sessions using the offsets

Extracting session sectors
--------------------------

If you still have the disk, put it in your CD drive and open ImgBurn. The TOC information on the side bar will print the logical block address (LBA) for the start of a session. Example::

    TOC Information:
    Session 1... (LBA: 0 / 00:02:00)
    -> Track 01  (Mode 1, LBA: 0 / 00:02:00)
    -> LeadOut  (LBA: 8412 / 01:54:12)
    Session 2... (LBA: 19812 / 04:26:12)
    -> Track 02  (Mode 1, LBA: 19812 / 04:26:12)
    -> LeadOut  (LBA: 48482 / 10:48:32)
    Session 3... (LBA: 55382 / 12:20:32)
    -> Track 03  (Mode 1, LBA: 55382 / 12:20:32)
    -> LeadOut  (LBA: 109690 / 24:24:40)

From this, we see:

-   Session 1 starts at LBA 0
-   Session 2 starts at LBA 19812
-   Session 3 starts at LBA 55832

If you have the ``.CUE`` sheet, you may be able to get the address from the time. Times are reported in ``min:sec:frames`` format; there are 75 "frames" in a second so ``LBA = (min * 60 * 75) + (sec * 75) + frames``. Example::

    FILE "1stPhoto-Nov-04.bin" BINARY
    REM SESSION 01
        TRACK 01 MODE1/2352
          INDEX 01 00:00:00
          REM TAOGAP 00:00:02
      REM LEAD-OUT 01:52:12
    REM SESSION 02
        TRACK 02 MODE1/2352
          INDEX 01 04:24:10
          REM TAOGAP 00:00:02
      REM LEAD-OUT 10:46:32
    REM SESSION 03
        TRACK 03 MODE1/2352
        INDEX 01 12:18:28

``REM`` are comments that ImgBurn has added for our benefit.

-   Session 1 track 1 has a time of ``00:00:00`` so naturally the LBA is 0.
-   Session 2 track 1 has a time of ``04:24:10``. Using the formula, we get ``LBA = (4 * 60 * 75) + (24 * 75) + 10 = 19810``... wait we know from earlier that this should be 19812! Where did the 2 frames go? Well, see the "TAOGAP" comment? This means there is a 2 frames of padding/junk after the previous track! So our formula is actually ``LBA = (min * 60 * 75) + (sec * 75) + frames + taogap = 19810 + 2 = 19812``

    .. note::

        TAO stands for Track At Once. See this forum entry for more: https://forum.imgburn.com/topic/20894-2570-always-hangs-at-99-for-writes-and-verifys/#comment-144868

-   Session 3 track 1 has a time of ``12:18:28``. We get: ``LBA = (12 * 60 * 75) + (18 * 75) + 28 + 2 = 19810 + 2 = 55380``... wait that's wrong again! It should be 55382! Maybe we have to accumulate TAOGAPs? idk at this point

.. warning::

    If you don't have the ``.CUE`` sheet, here's a way that kinda/sorta/doesn't work: we could iterate over all sectors of a single-session user data conversion of the RAW disk image. The process is outlined below but note that the results are off since they don't account for the TAOGAP! And they'll look right because the adjacent sectors may also be directly listings, but this is misleading! So it "works" but you just have to adjust for the TAOGAP otherwise you can't read all the data.

    #.  Convert the RAW disk iamge to a single-session User Data ``.ISO`` using ``bchunk`` with a "fake" ``.CUE`` sheet

        ``.CUE`` sheet (``fake.cue``)::

            FILE "1stPhoto-Nov-04.bin" BINARY
                TRACK 01 MODE1/2352
                    INDEX 01 00:00:00

        Run ``bchunk``:

        .. code-block:: shell

            bchunk disk.bin fake.cue fake

        This should generate ``fake01.iso`` which is approx 87% of the size of ``disk.bin``.

    #.  Using ``isoinfo``, try all possible sector offsets to find valid sessions. To generate all possible sector offsets, divide the size of the ISO file by the ISO sector offset of 2048.

        .. code-block:: shell

            isoinfo -i CD.iso -T [sector number]

        Example session. Note than a valid sector candidate prints nothing and exits with 0; an invalid sector candidate prints "CD-ROM is NOT in ISO 9660 format" or "Short read on old image" and exits with 1::

            $ isoinfo -i fake01.iso -T 0

            $ echo $?
            0

            $ isoinfo -i fake01.iso -T 1
            CD-ROM is NOT in ISO 9660 format

            $ echo $?
            1

        Sample python script:

        .. code-block:: python

            import os
            import subprocess
            import sys

            ISO_SECTOR_OFFSET = 2048
            # The `bchunk` output using a fake "single-session" .CUE sheet
            USER_DATA_FILE = "fake01.iso"

            EXPECTED_OUTPUTS = [
                "",
                "CD-ROM is NOT in ISO 9660 format",
            ]


            def print_progress(offset: int, file_size: int, msg: str):
                progress_percent = int(offset / file_size * 100)  # chop off decimals
                print(f"\r{offset}/{file_size} ({progress_percent}%): {msg}", end="", flush=True)


            def main() -> int:
                """Returns exit code: 0 on success, non-0 on error"""
                valid_sectors: list[int] = []

                file_size = os.path.getsize(USER_DATA_FILE)
                if (file_size % ISO_SECTOR_OFFSET) != 0:
                    print(f"ISO invalid: size is not a multiple of {ISO_SECTOR_OFFSET}")
                    return 1

                sector_count = int(file_size / ISO_SECTOR_OFFSET)
                for sector in range(0, sector_count):
                    result = subprocess.run(["isoinfo", "-i", USER_DATA_FILE, "-T", str(sector)], capture_output=True)
                    output = result.stdout.decode().strip()
                    error = result.stderr.decode().strip()

                    # Determine if something is catastrophically wrong
                    if output not in EXPECTED_OUTPUTS or error not in EXPECTED_OUTPUTS:
                        print("Unexpected isoinfo output, have you done something wrong?")
                        if output:
                            print(f"stdout: {output}")
                        if error:
                            print(f"stderr: {error}")
                        return 1

                    # Figure out which message to show the user
                    if output:
                        to_print = output
                    else:
                        to_print = error

                    print_progress(sector, sector_count, to_print)

                    # Exit code of 0 means that we found a candidate!
                    if result.returncode == 0:
                        # Print a new line to avoid carriage return shenanigans in print_progress
                        print(f"\nFOUND ONE! {sector}")
                        valid_sectors.append(sector)

                print(f"valid_sectors: {valid_sectors}")
                return 0


            if __name__ == "__main__":
                sys.exit(main())

        TODO: This is a very slow process! Can this be sped up by incorporating the specific ``isoinfo`` function into a C program?

Extracting files from sessions using the sectors
------------------------------------------------

#.  Use ``bchunk`` to convert the multi-session RAW to multiple single-track ``.ISO``:

    .. code-block:: shell

        bchunk disk.bin disk.cue disk

    For our 3 session example above, this should produce 3 files: ``disk01.iso``, ``disk02.iso``, and ``disk03.iso``

#.  Use ``isoinfo -l`` to list the directores using the sectors you found earlier:

    .. code-block:: shell

        isoinfo -i disk01.iso -l -N 0
        isoinfo -i disk02.iso -l -N 19812
        isoinfo -i disk03.iso -l -N 55382

#.  Use ``isoinfo -x`` to extract files.

    .. code-block:: shell

        isoinfo -i disk03.iso -N 55382 -x '/MY/PATH/TO/FILE.TXT;1' > file.txt

    .. note::

        If the path doesn't exist, ``isoinfo`` will not produce an error and--adding insult to injury--will return 0 (success). The only way to tell if it worked is to check if your file is empty or not!

Mount ``.ISO`` in Windows 11
============================

For some reason, Explorer doesn't give me a "Mount" option. However, you can mount from Powershell:

.. code::

    Mount-DiskImage -ImagePath "C:\full\path\to\disk.iso"

.. warning::

    ``Mount-DiskImage`` expects a full path!

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
.. _Dietrich at al: https://journal.code4lib.org/articles/17208
.. _cue sheet: https://en.wikipedia.org/wiki/Cue_sheet_(computing)
