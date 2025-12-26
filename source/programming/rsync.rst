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

Use ``-r`` to upload recursively. Use ``-P`` for progress. Use ``--exclude`` to ignore certain files; if you have enough exclusions then you can put them in a file and use ``--exclude-from`` instead.

Example::

    rsync -r -P --exclude-from rsync-excludes.txt your/local/folder/ user@example.com:your/dest/folder/

