Sphinx
======

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
