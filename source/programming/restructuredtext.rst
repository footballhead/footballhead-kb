reStructuredText
================

Text markup language. reStructuredText pre-dates Markdown, despite the overwhelming prevelance of the latter in 2026.

Part of `docutils`_. While you can use docutils to generate output, :doc:`sphinx` is typically what people use to create entire websites; it's basically a strict superset of functionality.

.. _docutils: https://docutils.sourceforge.io/

Getting Started
---------------

.. highlight:: sh

Install docutils from pip::
    
    pip install docutils

Run docutils on an ``.rst`` file::

    docutils README.rst > README.html

Terminology
-----------

.. highlight:: rst

directive
    Generic block-level elements (think ``<div>``) of `explicit markup <https://docutils.sourceforge.io/docs/user/rst/quickref.html#explicit-markup>`_. Designed as a `"a general-purpose extension mechanism" <https://docutils.sourceforge.io/docs/user/rst/quickref.html#directives>`_. Here's an example::

        .. note:: This is an admonition or callout which is rendered to stand out from the surrounding text.

    -   Here's the list of reStructuredText directives: https://docutils.sourceforge.io/docs/ref/rst/directives.html
    -   Here's the list of additional :doc:`sphinx` directives: https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html
    -   Here's the docutils guide for creating new directives: https://docutils.sourceforge.io/docs/howto/rst-directives.html
    -   Here's the :doc:`sphinx` guide for creating new directives: https://www.sphinx-doc.org/en/master/development/tutorials/extending_build.html

interpreted text
    Anything enclosed by backticks `````. If no role is specified, the default role is used (which for me seems to be ``emphasis``).

role
    Inline elements (think ``<span>``) of interpreted text. Example::

        :emphasis:`This text is emphasized`

    -   Here's the list of reStructuredText roles: https://docutils.sourceforge.io/docs/ref/rst/roles.html
    -   Here's the :doc:`sphinx` guide for creating roles: https://www.sphinx-doc.org/en/master/development/tutorials/extending_syntax.html#tutorial-extending-syntax

markup
    Anything that's not a directive or a role. Refer to `reStructuredText Markup Specification`_ for a complete list.

explicit markup block
    A line starting with two dots followed by space. An example is a hyperlink target::

        .. _docutils: https://docutils.sourceforge.io/

.. _reStructuredText Markup Specification: https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html

:acronym:`test` is an abbrevation

Tips
----

Always use 4 space indenting. The tools will be lenient but, if not strictly followed, then output may not look as expected.

Additionally, always have an empty line between blocks, e.g. the start of a sublist. Taken to the extreme, always put an empty line between all logical elements::

    Notice that the list item markup is at the start but the item text is indented.
    Using just 1 space instead of two can throw off the parser!

    #.  This is a list item
    #.  This is another item in the list.

    #.  This is a third item in the list. Notice the newline between this and the previous item.

        -   This is a the start of a sublist. Notice the newline before the start and after the end of the sublist.

    #.  This is the fourth item in the list.

Cheat Sheet
-----------

Syntax highlighting is done with `pygments`_

.. _pygments: https://pygments.org/languages/

reference::

    A hyperlink to the `docutils`_ website

    This is a hyperlink target:

    .. _docutils: https://docutils.sourceforge.io/

emphasis (aka italics)::

    This text is *emphasized*.

strong emphasis (aka bold)::

    This text is **strongly emphasized**.

literal blocks::

    This indented block will be rendered as-is::
        
        :doc:`sphinx` goes one step further and applies syntax highlighting

    so will

    ::

        this block

.. note:: Using ``docutils``, this will not have syntax highlighting. However, using :doc:`sphinx`, it will. The language is controlled with the ``.. highlight:: <language>`` directive.

