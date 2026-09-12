README
======

Michael Hitchens's Knowledge Base. Authored as reStructuredText and rendered with Sphinx.

Hosted at http://www.michaelhitchens.com/kb

Developing
----------

Install Python and virtualenv. Then:

.. code:: shell

    # Make a virtualenv; ./venv is ignored
    python3 -m venv ./venv

    # Activate the virtualenv
    # On Linux/macOS:
    . ./venv/bin/activate
    # On Windows (Powershell):
    .\venv\Scripts\Activate.ps1
    # On Windows (cmd.exe):
    venv\Scripts\activate.bat

    # Install required dependencies inside venv
    pip install sphinx furo

    # Build the docs
    sphinx-build source build 

    # Open build/index.html

(Optional) Install ``sphinx-autobuild`` so the site is regenerated as you modify the .rst files:

.. code:: shell

    pip install sphinx-autobuild
    sphinx-autobuild source build

Deploying
---------

Run ``upload`` (requires ``rsync``)::

    ./upload user example.com kb

.. _pipenv: https://github.com/pypa/pipenv
