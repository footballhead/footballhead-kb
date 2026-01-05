==================
Time Bandit (1988)
==================

`Time Bandit`_ is a maze/shoot-em-up inspired by `Tutankham`_. Initially released in 1983 for the TRS-80 Model 1, it has a long history of ports.

I'm most familiar with the 1988 DOS port.

I started writing some tools: https://github.com/footballhead/bandit-utils

-----------
Anti-Piracy
-----------

This game has copy protection! Details: https://tcrf.net/Time_Bandit_(DOS)

I found a partial list of answers: https://www.abandonwaredos.com/docs.php?sf=timebanditcopyprot.txt&st=copy+protection&sg=Time+Bandit&idg=2950

-   Start a new game
-   Go to the old bomb factory
-   If the bombs shoot lasers then your version was improperly cracked and, as a result, has tripped the anti-piracy!

Properly circumvented:

-   https://dosgamezone.com/download/time-bandit-3970.html

    .. note:: This is interesting because the ZIP contains ``BANDIT.EX_``, which is uncracked!

-   https://classicreload.com/time-bandit.html

Improperly circumvented:

-   https://www.myabandonware.com/game/time-bandit-jf
-   https://www.abandonwaredos.com/abandonware-game.php?abandonware=Time+Bandit&gid=2950

I took a look at cracking this at one point... I remember a hashing algorithm and a table of (hashed) answers sitting in code. I figure it should be possible to document the hash algorithm then brute force the table of passwords.

-------------------
Reverse-Engineering
-------------------

I threw this in IDA in hopes of understanding how to rip the graphics.

EXEPACK
=======

Loading ``BANDIT.EXE`` into IDA gives this prompt:

    Possibly packed file, continue?

``EXEPACK`` is a thing that Microsoft made: http://justsolve.archiveteam.org/wiki/EXEPACK

Build and use ``unEXEPACK`` before throwing it in IDA or debugging: https://github.com/w4kfu/unEXEPACK

.. tip:: Use my fork with CMake support! https://github.com/footballhead/unEXEPACK/tree/cmake

IDA Notes
=========

#.  Unpack first (see EXEPACK section)
#.  Use IDA 5.0 (works OK with Wine!)
#.  After autoanalysis, the segments are all messed up. Only seg000, seg001, seg002, seg003, seg007, seg011, seg015, seg018, seg046 are referenced in code. Might be able to figure out segments by looking at relocation tables...

    -   seg000 is code (and some data/rdata)
    -   seg001 and seg003 are buffers
    -   seg046 is rdata/data segment
    -   seg047 through seg058 are probably fake news. They're most likely extensions of seg046
    -   seg059 is the last segment (it's the stack so it has to be???). It's never referred to by itself, only as an offset from seg046
    -   seg060 and above are fake

Debugging
=========

.. tip:: I recommend unpacking first, see EXEPACK section

Compile DOSBOX for debug::

    svn checkout https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk dosbox-code-0
    sudo apt install automake autoconf libsdl1.2-dev 
    ./autogen.sh
    ./configure --enable-debug=heavy
    make -j $(nproc)

Run DOSBOX, mount folder, and run ``DEBUG BANDIT.EXE``

.. warning:: Running ``DEBUG`` helps because it adds a breakpoint at program entry. However, it also changes where the program is loaded in memory. Normally, with DOSBOX, the PSP is at seg 0x0192, but with DEBUG it's 0x01DD. That puts the code segment at 0x01ED.

Files
=====

TITLE.SCR
---------

RLE-encoded data.

RLE-decode algorithm (starts at ``seg000:0137``):

-   Data is organized into runs
-   Each run starts with an encoded length
-   For each run (N = length):

    -   If N == 0x80 then stop
    -   If N < 0 then repeat the next byte (-N) + 1 times. Total size of this run is 2 bytes (1 byte length + 1 byte data). That means compression comes if same byte is repeat 3+ times
    -   If N > 0 then copy the next N bytes. Total size of this run is 1+N bytes (1 byte length + N bytes of data)

Data (uncompressed)::

    struct title_data {
        // Code 437 text data
        // 80 for number of columns on display
        // +2 for newlines \r\n
        // 25 for number of rows on display
        unsigned char code437[(80+2)*25];
        // DOS 4-bit text mode color
        unsigned char color[(80+2)*25];
    };

    struct title_scr {
        // 0 is credits
        // 1 is settings
        // 2 is password
        title_data[3] data;
    };

This means the file is laid out like this (alternating code437 and color):

-   title_scr.data[0].code437
-   title_scr.data[0].color
-   title_scr.data[1].code437
-   title_scr.data[1].color
-   title_scr.data[2].code437
-   title_scr.data[2].color

At runtime, the game will interleave code and color (also throw away ``\r\n``) so it can memcpy to display memory.

------
Videos
------

-   Tutankham (1982): https://www.youtube.com/watch?v=7Z242gkTzmM
-   TRS-80 Model I (1983): https://www.youtube.com/watch?v=QgRQC1HhKu0
-   TRS-80 CoCo (1983): https://www.youtube.com/watch?v=eoIsJ0qjwcU
-   Sanyo MBC-550 (1984): https://www.youtube.com/watch?v=cN2wnCBQ1uo
-   Atari ST (1986): https://www.youtube.com/watch?v=wH3zPffUnz8
-   Amiga (1988): https://www.youtube.com/watch?v=fZsgmEvn0vU

-------------------------
Reference (DOS, x86, etc)
-------------------------

-   DOSBox source: http://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk/
-   Art of Assembly Language - Chapter 23: PC Video Display: https://www.plantation-productions.com/Webster/www.artofasm.com/DOS/ch23/CH23-1.html
-   Keyboard scan code/character code combinations - PC DOS Retro: https://web.archive.org/web/20220407232513/https://sites.google.com/site/pcdosretro/scancodes
-   PORTS Common I/O Port Addresses: https://stanislavs.org/helppc/ports.html
-   24. Switching Around Your DOS Video Mode: http://lateblt.tripod.com/bit24.txt (from http://lateblt.tripod.com/infobits.htm)
-   Program Segment Prefix (accessing DS when not explicitly set!): https://en.wikipedia.org/wiki/Program_Segment_Prefix
-   DOS Interrupts: https://spike.scu.edu.au/~barry/interrupts.html
-   Interrupt Vector Table: https://wiki.osdev.org/Interrupt_Vector_Table
-   Memory Layout and Memory Map: http://flint.cs.yale.edu/feng/cos/resources/BIOS/mem.htm
-   Intel x86 JUMP quick reference: http://unixwiz.net/techtips/x86-jumps.html
-   Notes on the format of DOS .EXE files: http://www.tavi.co.uk/phobos/exeformat.html
-   MZ: https://wiki.osdev.org/MZ
-   BDA - BIOS Data Area - PC Memory Map: https://stanislavs.org/helppc/bios_data_area.html
-   Mapping DOS Memory Allocation | Dr Dobb's: https://www.drdobbs.com/architecture-and-design/mapping-dos-memory-allocation/184408026

----
Misc
----

-   Harry Lafner Interview: https://www.atarilegend.com/interviews/4
-   Manual (Atari ST): https://bytecellar.com/media/Time_Bandit-Manual.pdf
-   http://www.trs-80.org/time-bandit/

.. _Time Bandit: https://en.wikipedia.org/wiki/Time_Bandit
.. _Tutankham: https://en.wikipedia.org/wiki/Tutankham