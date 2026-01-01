Sphinx
======

Sphinx generates a website from text markdown.

Why Sphinx?
-----------

- Write markup (reStructuredText), render HTML
- Python-based (my personal preference)

Terminology
-----------

reStructuredText:

-   Directive: generic block-level elements of `explicit markup <https://docutils.sourceforge.io/docs/user/rst/quickref.html#explicit-markup>`_. Designed as a `"a general-purpose extension mechanism" <https://docutils.sourceforge.io/docs/user/rst/quickref.html#directives>`_.

    -   reStructuredText directives: https://docutils.sourceforge.io/docs/ref/rst/directives.html.
    -   Sphinx directives: https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html
    -   reStructuredText guide for creating directives: https://docutils.sourceforge.io/docs/howto/rst-directives.html
    -   Sphinx guide for creating directives: https://www.sphinx-doc.org/en/master/development/tutorials/extending_build.html

-   Role: inline elements of interpreted text.

    - reStructuredText roles: https://docutils.sourceforge.io/docs/ref/rst/roles.html
    - Sphinx guide for creating roles: https://www.sphinx-doc.org/en/master/development/tutorials/extending_syntax.html#tutorial-extending-syntax

Easily create external link roles via sphinx.ext.extlinks
---------------------------------------------------------

Sometimes, you want to refer to subpages of reference documentation but don't want to spell out the entire link over and over. You can create custom roles that include the base link for you.

#.  Open ``conf.py``.

#.  Find the ``extentions`` list. Add ``sphinx.ext.extlinks``

#.  Define `extlinks <https://www.sphinx-doc.org/en/master/usage/extensions/extlinks.html>`_

    .. code-block:: python

        extlinks = {'issue': ('https://github.com/sphinx-doc/sphinx/issues/%s',
                        'issue %s')}

#.  In your ``.rst``, use like::

        :issue:`123`

https://www.sphinx-doc.org/en/master/usage/extensions/extlinks.html

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
