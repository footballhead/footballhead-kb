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

Deploying
---------

Sometimes Sphinx doesn't generate the sitemap properly on all pages. I recommend cleaning before making and deploying::

    pipenv run make clean
    pipenv run make html
    rsync -r -P --exclude-from rsync-excludes.txt build/html DEST
