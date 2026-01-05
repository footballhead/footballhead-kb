Git LFS
=======

LFS stands for "large file storage". In essence, git will store a pointer to a server hosting a large file instead of the file itself. The server will hash the file and store the file on disk renamed with the hash. During checkout, git will substitute the pointer with the actual file.

It looks like it's up to each git server to decide on an `implementation <https://github.com/git-lfs/git-lfs/wiki/Implementations>`_ for how/where to store the files. E.g. GitHub LFS probably looks different than GitLab LFS. 

That said, you can use LFS with a local clone from a bare repo. The file will be stored in ``$BARE_REPO_ROOT/lfs/objects/$X/$Y/$HASH`` where ``$X`` is the first two characters of the hash, ``$Y`` are the next two characters of the hash, and ``$HASH`` is the full hash.

See the `git-lfs`_ manual.

#.  Use ``git lfs`` to tell git which files should use LFS
#.  Commit ``.gitattributes``
#.  Use like normal git

Ideally, you'd decide what is in/out of LFS at repo creation time.

On Windows
----------

If you want Windows to be the host of Git LFS, note the following:

-   There is no SSH-only version. If you want something equivalent: use ``sshfs`` to mount the bare git repo directory then clone from that.

.. _git-lfs: https://git-lfs.com/
