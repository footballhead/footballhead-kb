Monorepo
========

So you want a `monorepo`_... There's two things to think about:

#. How do you store source?
#. How do you build?

Version Control
---------------

Some options:

- One git repo: easiest to conceptualize but hard to firewall off certain folders (e.g. due to licensing)
- ``repo``: Orchestrates a bunch of git repos. What Android uses
- ``jiri``: Similar to ``repo``, see this `StackOverflow post <https://stackoverflow.com/questions/46649037/what-are-the-main-differences-betwen-repo-and-jiri>`_. What Fuschia uses
- git submodules: Add references to other git repos inside a git repo. Kinda cluncky but it works.

.. _monorepo: https://en.wikipedia.org/wiki/Monorepo

Build System
------------

Build systems for a monorepo often have a prescribed workflow and one command to do everything. Some criteria:

- Can do per-target compilation; doesn't build things that you don't need
- Supports building for multiple architectures. E.g. one command to build both the host tools and the target binaries.
- How do I elegantly integrate other build ecosystems? E.g. Cargo, Python
- Does it support every platform? Bazel support on Windows is bad.
- How do third party dependencies work? Is each folder allowed to bring their own? Or do you have one copy somewhere?

If you look at other projects:

- Android uses a combination of soong/blueprints and Makefiles.
- Google likes to use Bazel
- Facebook uses Buck
- Chromium and Fuschia use gn

Some thoughts on CMake:

- It supports targets via ``cmake --build <build_dir> --target <target>``... however, most people are taught to run ``cmake --build <build_dir>`` which compiles the ``all`` target which includes everything. You need to manually annotate things with ``EXCLUDE_FROM_ALL``.
- Each target architecture is a separate cmake invocation and separate build dir. This means that, for example, your target artifacts can't depend on host build tools (without a lot of work...)
- CMake parses all build files during configure. This is typically where people fetch their dependencies. However, since you're not building the ``all`` target, this code should ideally by deferred until the target is build (otherwise, cmake configure will take a long time and will likely fail because you're missing something that's unrelated to the target you want to build). CMake doesn't have a good way to specify this.

Importing into git (via subtrees)
---------------------------------

git subtree makes it easy to split and combine git repos. While it isn't part of git core, most distributions package it anyway.

After your monorepo is set up, you can start importing repos into it with ``git subtree add``::

    git subtree -P <prefix> add <repository> <remote-ref>

* ``-P`` says which subdirectory in the monorepo the imported repo should live. This allows you to organize the code that you’re importing.
* ``<repository>`` is the thing you want to import, e.g. https://github.com/user/repo
* ``<remote-ref>`` is the branch or tag to import. Typically, this is main or master. (Annoyingly, this can't be an arbitrary SHA ref...)

git subtree works by fetching a copy of ``<repository>`` as a branch and establishing related histories with a merge commit. This means that the subtree is a copy!

Compared to submodules, subtrees exist independently of their remote. If the remote of the subtree is deleted, the subtree in your monorepo is a copy so it persists. With a submodule, if the remote of is deleted then you can no longer clone it.

Compared to good ol' copy-paste, subtrees preserve git history. Although if you don't want the history you can also ``--squash``.

.. warning::

    You need to include the merge commit otherwise future ``subtree pull`` won't work. On GitHub, this means you have to *Create a merge commit* when a PR is submitted; do not squash it! If you squash the merge during submission in GitHub then ``subtree pull`` no longer works; you'll need to delete the subtree and run ``subtree add`` again.

    This is because the ``<repository>`` history is a tree (an anonymous branch) and only exists inside your history via the merge commit. If you drop the merge commit then it's basically the same as copy-pasting code and now you have unrelated histories. Unrelated histories makes merge conflict resolution very difficult.
