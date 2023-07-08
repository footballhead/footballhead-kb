===
GIF
===

- Wikipedia: https://en.wikipedia.org/wiki/GIF
- Spec: https://www.w3.org/Graphics/GIF/spec-gif89a.txt

-------------------------------------------
Quilt Design as 46x46 uncompressed GIF.gif
-------------------------------------------

.. note:: From Wikipedia: https://upload.wikimedia.org/wikipedia/commons/archive/b/bb/20230514192610%21Quilt_design_as_46x46_uncompressed_GIF.gif

.. tip:: There's a visualization of the binary here: https://en.wikipedia.org/wiki/File:Uncompressed_gif_file.PNG

From the GIF spec::

    The Grammar.

    <GIF Data Stream> ::=     Header <Logical Screen> <Data>* Trailer

    <Logical Screen> ::=      Logical Screen Descriptor [Global Color Table]

    <Data> ::=                <Graphic Block>  |
                            <Special-Purpose Block>

    <Graphic Block> ::=       [Graphic Control Extension] <Graphic-Rendering Block>

    <Graphic-Rendering Block> ::=  <Table-Based Image>  |
                                Plain Text Extension

    <Table-Based Image> ::=   Image Descriptor [Local Color Table] Image Data

    <Special-Purpose Block> ::=    Application Extension  |
                                Comment Extension

Header (Chapter 17)
===================

Signature::

    0x47 0x49 0x46 == GIF (as string)

Version::

    0x38 0x39 0x61 == 89a (as string)

Logical Screen Descriptor (Chapter 18)
======================================

Logical screen width::

    0x2E 0x00 == 46 (base 10)

Logical Screen Height::

    0x2E 0x00 == 46 (base 10)

Packed Fields::

    0xF6 == 11110110 (in binary)
            ^        1: Yes global color table (with background color)
             ^^^     7: Original image had 7+1 = 8 bits per primary color (why does this matter???)
                ^    0: No, color table is not sorted
                 ^^^ 6: Size of global color table is 3 x 2^(6+1) = 3 x 2^7 = 384

Background color::

    0x00

Pixel Aspect Ratio::

    0x00 == no aspect ratio given

Global Color Table (Chapter 19)
===============================

We know from the Logical Screen Descriptor that:

- Yes, we have a global color table
- The original image had ``7+1`` bit color (does this matter???)
- It's not sorted
- There's ``3 x 2^(6+1)`` bytes

Here they are in order::

    0x08 0x6B 0x52 | red = 8, green = 107, blue = 82
    0x08 0x6B 0x5A
    0x10 0x6B 0x5A
    0x10 0x73 0x5A
    0x10 0x73 0x63
    0x18 0x73 0x63
    0x18 0x7B 0x63
    0x21 0x7B 0x6B
    0x29 0x7B 0x6B
    0x29 0x84 0x73
    0x52 0xAD 0x9C
    0x5A 0xB5 0x9C
    0x5A 0xB5 0xA5
    0x6B 0xC6 0xAD
    0x6B 0xC6 0xB5
    0x73 0xC6 0xB5
    0x73 0xCE 0xBD
    0x7B 0xAD 0x9C
    0x7B 0xCE 0xBD
    0x7B 0xD6 0xBD
    0x7B 0xD6 0xC6
    0x84 0xAD 0x9C
    0x84 0xB5 0xAD
    0x84 0xD6 0xC6
    0x8C 0xAD 0x9C
    0x8C 0xB5 0xAD
    0x8C 0xBD 0xB5
    0x8C 0xDE 0xCE
    0x8C 0xE7 0xD6
    0x94 0xB5 0xA5
    0x94 0xBD 0xB5
    0x9C 0xC6 0xBD
    0xB5 0xBD 0xA5
    0xB5 0xBD 0xAD
    0xBD 0xBD 0xA5
    0xBD 0xBD 0xAD
    0xCE 0x63 0x08
    0xCE 0x6B 0x10
    0xCE 0x6B 0x18
    0xCE 0x73 0x18
    0xCE 0x73 0x21
    0xCE 0x73 0x29
    0xCE 0x7B 0x31
    0xCE 0x84 0x39
    0xCE 0xC6 0xA5
    0xD6 0x73 0x18
    0xD6 0x73 0x21
    0xD6 0x7B 0x29
    0xD6 0x7B 0x31
    0xD6 0x84 0x39
    0xDE 0x7B 0x29
    0xDE 0x84 0x31
    0xDE 0x84 0x39
    0xDE 0x94 0x52
    0xDE 0x94 0x5A
    0xDE 0x9C 0x5A
    0xDE 0x9C 0x63
    0xDE 0xA5 0x6B
    0xDE 0xBD 0x9C
    0xE7 0x18 0x5A
    0xE7 0x21 0x63
    0xE7 0x29 0x63
    0xE7 0x29 0x6B
    0xE7 0x31 0x6B
    0xE7 0x39 0x73
    0xE7 0x42 0x73
    0xE7 0x4A 0x73
    0xE7 0x52 0x73
    0xE7 0x52 0x7B
    0xE7 0x5A 0x7B
    0xE7 0x8C 0x39
    0xE7 0x8C 0x42
    0xE7 0x94 0x42
    0xE7 0xAD 0x7B
    0xE7 0xB5 0x84
    0xE7 0xB5 0x8C
    0xE7 0xBD 0x8C
    0xE7 0xBD 0x94
    0xEF 0x39 0x73
    0xEF 0x39 0x7B
    0xEF 0x42 0x7B
    0xEF 0x4A 0x84
    0xEF 0x52 0x84
    0xEF 0x84 0xA5
    0xEF 0x8C 0xAD
    0xEF 0x94 0x4A
    0xEF 0x9C 0x4A
    0xEF 0x9C 0x52
    0xEF 0xAD 0xAD
    0xEF 0xB5 0xAD
    0xEF 0xBD 0x94
    0xEF 0xBD 0x9C
    0xEF 0xC6 0xA5
    0xEF 0xCE 0xAD
    0xEF 0xCE 0xB5
    0xEF 0xD6 0xB5
    0xF7 0x4A 0x84
    0xF7 0x52 0x84
    0xF7 0x52 0x8C
    0xF7 0x5A 0x8C
    0xF7 0x5A 0x94
    0xF7 0x63 0x94
    0xF7 0x8C 0xAD
    0xF7 0x94 0xB5
    0xF7 0x9C 0xB5
    0xF7 0x9C 0xBD
    0xF7 0xA5 0x5A
    0xF7 0xA5 0x63
    0xF7 0xA5 0xC6
    0xF7 0xAD 0x63
    0xF7 0xAD 0xC6
    0xF7 0xB5 0xCE
    0xF7 0xBD 0xCE
    0xF7 0xBD 0xD6
    0xF7 0xC6 0xD6
    0xF7 0xD6 0xBD
    0xF7 0xE7 0xCE
    0xFF 0x6B 0x9C
    0xFF 0xAD 0x6B
    0xFF 0xB5 0x6B
    0xFF 0xB5 0x73
    0xFF 0xD6 0xDE
    0xFF 0xEF 0xE7
    0xFF 0xFF 0xFF
    0xFF 0xFF 0xFF
    0xFF 0xFF 0xFF
    0xFF 0xFF 0xFF
    0xFF 0xFF 0xFF

Image Descriptor (Chapter 20)
=============================

Image Separator::

    0x2C | , (means this is an image descriptor block)

Image Left Position::

    0x00 0x00 | 0 (decimal): this image starts at the left-most edge

Image Top Position::

    0x00 0x00 | 0 (decimal): this iamge starts at the top-most edge

Image Width::

    0x2E 0x00 | 46 (decimal)

Image Height::

    0x2E 0x00 | 46 (decimal)

Packed Fields::

    0 | 00000000 (binary)
        ^        no local color table
         ^       image is not interlaced
          ^      local color table is not ordered
           ^^    reserved
             ^^^ size of local color table is 3x2^(0+1) which is 3 BUT there is no local color table

Local Color Table (Chapter 21)
==============================

There is no local color table

Table Based Image Data (Chapter 22)
===================================

LZW Minimum Code Size::

    0x07 | 7 (decimal): min size is 7

Image Data...

.. note::

    Here's a 46 x 46 uncompressed GIF with 7-bit symbols (128 colors, 8-bit
    codes). I put each raster in its own sub-block, with a CLEAR code at the
    beginning of each raster. Each raster sub-block thus has 48 bytes: length
    (47=2F) + CLEAR (80) + 46 bytes for 46 pixels. (This scheme has more CLEAR
    codes than necessary -- one for every 46 codes rather than the max of 126 --
    but it makes the addressing simpler.) The STOP code is in its own 2-byte
    sub-block at the end (01 + 81), followed by the terminating null sub-block
    (00). The global color table has 128 entries.

    \- `Elphion <https://en.wikipedia.org/wiki/Talk:GIF/Archive_1#c-Elphion-2011-05-24T01:48:00.000Z-Uncompressed_GIFs>`_

.. code::

    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 67 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 54 6E 7B 7B 7B 7B 7B 7B 7B
    ^
    ^ 0x2F | 47 (decimal): sub-block of 47 bytes
       ^ 0x80 | 100 (binary): CLEAR CODE (the CLEAR CODE at the beginning is what allows uncompressed data to follow... up to a limit that the author indicates above)
          ^ start of the first row, 46 bytes of index into global color table ------------------------------------------------------------------ ^

    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 3B 54 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 54 3B 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 3F 3E 67 7B 7B 7B 7B 7B 7B 7A 39 7B 7B 7B 7B 7B 7B 7B 7B 39 7A 7B 7B 7B 7B 7B 7B 67 3E 3F 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 65 3F 54 7B 7B 7B 7B 7B 7A 25 38 7B 7B 7B 7B 7B 7B 38 25 7A 7B 7B 7B 7B 7B 54 3F 65 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 65 3E 68 7B 7B 7B 7B 7A 26 2F 38 7B 7B 7B 7B 38 2F 26 7A 7B 7B 7B 7B 68 3E 65 75 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 75 62 41 4D 7B 7B 7B 7A 28 78 30 36 7B 7B 36 30 78 28 7A 7B 7B 7B 4D 41 62 75 75 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 75 63 41 25 4B 7B 7B 7A 28 78 78 2F 38 38 2F 78 78 28 7A 7B 7B 4B 25 41 63 75 75 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 68 67 67 67 67 67 67 6C 3D 52 75 63 41 28 28 4B 7B 7A 28 78 78 76 25 25 76 78 78 28 7A 7B 4B 28 28 41 63 75 52 3D 6C 67 67 67 67 67 67 68
    2F 80 70 3B 3F 41 41 41 41 3D 68 3E 52 63 41 2F 76 2E 49 7A 26 78 78 78 25 25 78 78 78 26 7A 49 2E 76 2F 41 63 52 3E 68 3D 41 41 41 41 3F 3B 70
    2F 80 7B 70 3D 63 75 75 75 64 3D 54 3D 41 41 2F 78 6D 28 4A 2F 47 78 78 25 25 78 78 47 2F 4A 28 6D 78 2F 41 41 3D 54 3D 64 75 75 75 63 3D 70 7B
    2F 80 7B 7B 70 3D 63 75 75 75 63 3D 54 3D 41 2F 78 78 6B 28 18 30 47 78 25 25 78 47 30 18 28 6B 78 78 2F 41 3D 54 3D 63 75 75 75 63 3C 70 7B 7B
    2F 80 7B 7B 7B 6F 3D 51 52 52 52 50 3B 68 44 2F 78 78 6D 28 01 18 2A 47 25 25 47 2A 18 01 28 6D 78 78 2F 44 68 3B 50 52 52 52 51 3D 6F 7B 7B 7B
    2F 80 7B 7B 7B 7B 6F 44 43 43 43 43 43 45 59 28 57 78 6D 28 04 07 18 2A 25 25 2A 18 07 04 28 6D 78 57 28 59 45 43 43 43 43 43 44 6F 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 5E 25 2E 34 34 34 34 26 4D 28 57 6D 28 05 17 07 18 2A 2A 18 07 17 05 28 6D 55 28 4D 26 34 34 34 34 2E 25 5E 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 5F 26 6A 78 78 78 6B 26 4B 28 47 28 05 1B 14 07 1D 1D 07 14 1B 05 28 47 28 4B 26 6B 78 78 78 6A 26 73 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 73 26 6A 78 78 78 6B 28 4A 26 28 05 1B 1B 12 01 01 12 1B 1B 05 28 26 4B 28 6B 78 78 78 6A 26 73 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 7B 5E 26 57 57 57 57 47 25 4C 2A 05 1B 1B 1B 01 01 1B 1B 1B 05 2A 4B 25 47 57 57 57 57 26 5E 7B 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 74 74 74 74 74 74 74 5C 2A 2A 2A 2A 2A 2A 2B 2C 05 0C 1B 1B 01 01 1B 1B 0C 05 2C 2B 2A 2A 2A 2A 2A 2A 5C 74 74 74 74 74 74 74 7B 7B
    2F 80 7B 7B 4A 25 28 2F 2F 2F 2F 28 20 02 05 09 09 09 09 05 1F 07 0B 1B 01 01 1B 0B 07 1F 05 09 09 09 09 05 02 20 28 2F 2F 2F 2F 28 25 4A 7B 7B
    2F 80 7B 7B 7B 4B 28 6D 78 78 78 57 26 22 05 0E 1B 1B 1B 0F 05 1A 06 0A 01 01 0A 06 1A 05 0F 1B 1B 1B 0E 05 22 26 57 78 78 78 6D 28 4D 7B 7B 7B
    2F 80 7B 7B 7B 7B 4D 28 6D 78 78 78 57 27 22 05 0E 1B 1B 1B 0F 05 19 05 01 01 05 19 05 0F 1B 1B 1B 0D 05 22 27 57 78 78 78 6D 28 4D 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 4B 28 6B 6D 6D 6D 47 26 20 05 0D 12 12 12 0C 02 1A 05 05 1A 02 0C 12 12 12 0D 05 20 26 47 6D 6D 6D 6B 28 4B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 4B 28 28 28 28 28 28 31 20 07 07 07 07 07 07 08 1E 1E 08 07 07 07 07 07 07 20 31 28 28 28 28 28 28 4B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 37 26 26 26 26 26 25 31 18 02 05 05 05 05 01 05 1E 1E 05 01 05 05 05 05 02 18 31 25 26 26 26 26 26 37 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 35 33 78 78 78 78 47 31 11 07 17 1B 1B 1B 0B 07 1F 02 02 1F 07 0B 1B 1B 1B 17 07 11 31 47 78 78 78 78 33 35 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 36 33 78 78 78 78 47 31 15 07 17 1B 1B 1B 0B 07 1F 05 01 01 05 1F 06 0B 1B 1B 1B 17 07 15 30 47 78 78 78 78 30 36 7B 7B 7B 7B
    2F 80 7B 7B 7B 36 30 78 78 78 78 47 30 18 07 17 1B 1B 1B 0C 07 1A 05 0F 01 01 0F 05 1A 07 0C 1B 1B 1B 17 07 18 30 47 78 78 78 78 30 36 7B 7B 7B
    2F 80 7B 7B 39 25 25 25 25 25 25 2A 1D 01 01 01 01 01 01 05 16 05 0F 1B 01 01 1B 0F 05 16 05 01 01 01 01 01 01 1D 2A 25 25 25 25 25 25 39 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 7B 7B 4B 25 25 25 25 25 25 28 3A 03 0F 1B 1B 01 01 1B 1B 0F 03 3A 28 25 25 25 25 25 25 4B 7B 7B 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 7B 49 2E 76 78 78 78 55 28 4D 29 05 1B 1B 1B 01 01 1B 1B 1B 05 29 4D 28 55 78 78 78 76 2E 49 7B 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 49 2F 76 78 78 78 55 28 4D 25 28 05 1B 1B 0F 02 02 0F 1B 1B 05 28 25 4D 28 55 78 78 78 76 2F 49 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 49 2F 76 78 78 78 55 28 4B 26 57 28 05 1B 0E 05 22 22 05 0E 1B 05 28 57 26 4D 28 55 78 78 78 76 2F 49 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 4B 25 25 26 26 26 26 28 4B 26 6B 6D 28 05 0D 05 22 28 28 22 05 0E 05 28 6D 6B 26 4B 28 26 26 26 26 25 25 4B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 67 3F 3F 3F 3F 3F 3F 41 58 26 6A 78 6D 28 02 05 20 26 25 25 28 20 05 02 28 6D 78 6A 26 58 41 3F 3F 3F 3F 3F 3F 67 7B 7B 7B 7B
    2F 80 7B 7B 7B 54 3D 63 65 65 65 50 3D 67 42 2F 78 78 6D 28 02 20 28 57 25 25 57 26 20 02 28 6D 78 78 2F 42 67 3D 50 65 65 65 63 3D 54 7B 7B 7B
    2F 80 7B 7B 53 3E 65 75 75 75 51 3E 69 3C 41 2F 78 78 57 28 20 26 57 78 25 25 78 57 26 20 28 57 78 78 2F 41 3C 68 3D 51 75 75 75 65 3E 54 7B 7B
    2F 80 7B 53 3F 65 75 75 75 51 3E 67 3D 51 41 2F 78 6A 26 5E 28 57 78 78 25 25 78 78 57 28 5E 26 6A 78 2F 41 51 3D 67 3E 51 75 75 75 65 3F 53 7B
    2F 80 54 3B 3D 3F 3F 3F 3F 3D 67 3D 64 63 41 2F 6A 26 73 7A 28 78 78 78 25 25 78 78 78 28 7A 73 26 6A 2F 41 63 63 3D 67 3D 3F 3F 3F 3F 3D 3B 67
    2F 80 79 79 79 79 79 79 79 70 3D 63 75 63 41 26 26 5E 7B 7A 28 78 78 6B 25 25 6D 78 78 28 7A 7B 5E 26 26 41 63 75 63 3D 70 79 79 79 79 79 79 79
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 75 63 41 25 5D 7B 7B 7A 28 78 6D 28 4B 4B 28 6D 78 28 7A 7B 7B 5D 25 41 63 75 75 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 75 52 41 5D 7B 7B 7B 7A 28 6D 28 4D 7B 7B 4D 28 6D 28 7A 7B 7B 7B 5D 41 52 75 75 40 6E 7B 7B 7B 7B 7B 7B 7B 
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 75 63 3D 6F 7B 7B 7B 7B 7A 26 28 4B 7B 7B 7B 7B 4B 28 26 7A 7B 7B 7B 7B 6F 3D 63 75 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 40 63 3C 70 7B 7B 7B 7B 7B 7A 25 4A 7B 7B 7B 7B 7B 7B 4A 25 7A 7B 7B 7B 7B 7B 70 3C 63 40 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 3E 3D 6F 7B 7B 7B 7B 7B 7B 7A 4B 7B 7B 7B 7B 7B 7B 7B 7B 4A 7A 7B 7B 7B 7B 7B 7B 6F 3D 3E 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6E 3C 6F 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 6F 3C 6E 7B 7B 7B 7B 7B 7B 7B
    2F 80 7B 7B 7B 7B 7B 7B 7B 6F 70 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 7B 70 6F 7B 7B 7B 7B 7B 7B 7B

    01 81
     ^
     ^ 0x01 | 1 (decimal): sub-block of 1 byte
       ^ 0x81 | STOP CODE, no more data!

    0x00 | block terminator - end of Table Based Image Data (see Appendix F)

Wait so how does this work to prevent LZW compression? Think about it from the decoder's point of view:

#. We need to constantly CLEAR the LZW dictionary only because this is a variable-length encoding; if it was fixed length then the dictionary would fill up and nothing spectacular would happen outside of the algorithm not generating new entries. However, with a variable-length encoding, if the size of the dictionary exceeds 0xFF then it will generate a 9-bit code and the decoder will start treating our 8-bit palettes as 9-bit! Chaos would ensue! The constant CLEARing of the table means the variable-length compression never exceeds 8 bits. We use 7-bit color so the global color table takes codes 0x00-0x7F. CLEAR takes 0x80. STOP takes 0x81. That leaves 0x82-0xFF for new entires. As long as we clear before 126 new entires then we're good. In this example we clear every 46 entires.
#. The decoder will generate new entries however it will never attempt to use them because our data doesn't contain them. That's because the original palette is less than 0x7F and the new dictionary entires are all greater than 0x82.

Trailer (Chapter 27)
====================

The trailer indicates end of the data stream and is one character::

    0x3B | ;