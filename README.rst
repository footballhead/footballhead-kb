README
======

Michael Hitchens Knowledge Base. Authored as reStructuredText and rendered with Sphinx

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
