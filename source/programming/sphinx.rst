Sphinx
======

Sphinx generates a website from text markdown.

Why Sphinx?
-----------

- Write markup, render HTML
- Python-based (my personal preference)

Making a new Sphinx Site
------------------------

Install ``sphinx``. I use ``pipenv`` to manage dependencies (but you could easily install via ``pip``):

#. Install pipenv: https://github.com/pypa/pipenv
#. ``mkdir my-sphinx-project && cd my-sphinx-project``
#. ``pipenv install sphinx``

Generate a template site::

    pipenv run sphinx-quickstart
    # Fill out the CLI wizard. I used separate source and build dirs

Test build::

    pipenv run make html

View your site::

    cd build/html
    python -m http.server 8000
    # Open localhost:8000 in your browser

Start modifying ``source/index.rst``

Using Read the Docs theme
-------------------------

There are many built-in themes and many community themes. My personal go-to at the moment is the Read the Docs theme. I think it's the most clean, modern, and widely recognizable.

#. ``pipenv install sphinx-rtd-theme``
#. Open ``source/conf.py``, change ``html_theme`` to ``sphinx_rtd_theme``
#. Rebuild: ``pipenv run make html``

Picking a theme
---------------

Don't like the defaults? Try https://sphinx-themes.readthedocs.io/en/latest/

Quirks
------

If a new file is added to ToC, the sidebar on old pages may not be updated. This may not be a problem if you're iterating, but can be an issue when you go to publish artifacts.

If you want to regenerate the sidebar on old pages, you'll need to do a clean build::

    pipenv run make clean
    pipenv run make html
