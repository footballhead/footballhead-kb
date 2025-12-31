README
======

Michael Hitchens's's's Knowledge Base. Authored as reStructuredText and rendered with Sphinx.

Hosted at http://www.michaelhitchens.com/kb

Developing
----------

Setup:

* Install pipenv: https://github.com/pypa/pipenv
* ``pipenv install`` to get Sphinx

Building::

    pipenv run make html

Viewing::

    cd build/html
    python -m http.server 8000
    # Open http://localhost:8000 in your browser

(Alternatively, open ``build/html/index.html`` in a browser.)

Deploying
---------

Run ``upload.sh``::

    ./upload.sh foo@bar.com:kb
