=====
rsync
=====

I used to use `Filezilla <https://filezilla-project.org/>`_ to upload things to my website. However, SFTP mode is kinda slow... I was put off using ``rsync`` for a while since it's a scary CLI only tool but it's SO MUCH FASTER.

------
Basics
------

The basics::

    rsync SRC DEST

``SRC`` and ``DEST`` can be a local file (``./foo.txt``) or SSH location (``user@example.com``).

Use ``-r`` to upload recusrively.

If you want to upload everything from the current directory to a specific folder on a host::

    cd your/directory/to/upload
    rsync -r . user@example.com:your/specific/folder
