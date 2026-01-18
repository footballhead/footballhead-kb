README
======

Michael Hitchens's's's Knowledge Base. Authored as reStructuredText and rendered with Sphinx.

Hosted at http://www.michaelhitchens.com/kb

Developing
----------

Setup:

-   Install pipenv: https://github.com/pypa/pipenv
-   ``pipenv install`` to get Sphinx

Building::

    pipenv run make autobuild

This starts a process to rebuild when there are file changes. View at http://localhost:8000 in your browser

Deploying
---------

Run ``upload`` (requires ``rsync``)::

    ./upload user example.com kb
