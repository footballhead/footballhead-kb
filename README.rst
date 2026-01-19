README
======

Michael Hitchens's Knowledge Base. Authored as reStructuredText and rendered with Sphinx.

Hosted at http://www.michaelhitchens.com/kb

Developing
----------

Install dependencies with `pipenv`_:

.. code:: shell

    pipenv install

Build:

.. code:: shell

    pipenv run make autobuild

This starts a process whichs rebuilds the site when you save changes. View at http://localhost:8000 in your browser

In VSCode, you can preview output in editor using Simple Browser.

Developing (Steam Deck)
-----------------------

SteamOS provides Python 3.13 with virtualenv. Since it seems a little ridiculuous to install Pipenv in a virtualenv, just use the venv:

.. code:: shell

    python3 -m venv path/to/your/venv
    . path/to/your/venv/bin/activate
    pip install sphinx furo

SteamOS doesn't provide make, so build by hand:

.. code:: shell

    sphinx-build source build 

(Optional) Install ``sphinx-autobuild`` so the site is regenerated as you modify the .rst files:

.. code:: shell

    pip install sphinx-autobuild
    sphinx-autobuild source build

Deploying
---------

Run ``upload`` (requires ``rsync``)::

    ./upload user example.com kb

.. _pipenv: https://github.com/pypa/pipenv
