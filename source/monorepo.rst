Monorepo
========

So you want a `monorepo`_... Some options:

- One git repo: easiest to conceptualize but hard to firewall off certain folders (e.g. due to licensing)
- ``repo``: Orchestrates a bunch of git repos. What Android uses
- ``jiri``: Similar to ``repo``, see this `StackOverflow post <https://stackoverflow.com/questions/46649037/what-are-the-main-differences-betwen-repo-and-jiri>`_. What Fuschia uses
- git submodules: Add references to other git repos inside a git repo. Kinda cluncky but it works.

.. _monorepo: https://en.wikipedia.org/wiki/Monorepo