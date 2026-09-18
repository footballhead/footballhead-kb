=====
Rogue
=====

https://en.wikipedia.org/wiki/Rogue_(video_game)

The game that started it all. I'm interested in its level gen algorithm.

-----------
Source code
-----------

There is no one page that catalogues the entire history of Rogue. Here's some useful pages

-   The Rogue Archive: https://britzl.github.io/roguearchive/
-   Original Rogue Game (5.4.4): https://github.com/Davidslv/rogue
-   Roguelike Restoration Project: http://rogue.rogueforge.net/

Original Rogue Game (5.4.4)
===========================

Download: https://github.com/Davidslv/rogue

.. note::

    The source uses tabs at 8 spaces. The identation scheme is: each indent is 4 spaces; 8 spaces becomes a tab.

The README says that it uses the GNU Build System:

.. code-block:: shell

    ./configure
    make

However, we need to do a few more things:

#.  Specify an older compiler standard to configure, e.g. ``-std=gnu89``
#.  Compile ncurses without opaque structs

After that, we can run build:

.. code-block:: shell

    ./configure CFLAGS="-std=gnu89 -I$HOME/local/include/ncursesw"
    make LDFLAGS="-L$HOME/local/lib"

Function with no parameter specification
----------------------------------------

On modern systems, ``make`` likely isn't going to work::

    gcc -g -O2  -DHAVE_CONFIG_H  -c daemon.c
    daemon.c: In function ‘do_daemons’:
    daemon.c:112:14: error: too many arguments to function ‘dev->d_func’; expected 0, have 1
    112 |             (*dev->d_func)(dev->d_arg);
        |             ~^~~~~~~~~~~~~ ~~~~~~~~~~
    In file included from daemon.c:15:
    rogue.h:732:12: note: declared here
    732 |     void (*d_func)();
        |            ^~~~~~
    daemon.c: In function ‘do_fuses’:
    daemon.c:179:14: error: too many arguments to function ‘wire->d_func’; expected 0, have 1
    179 |             (*wire->d_func)(wire->d_arg);
        |             ~^~~~~~~~~~~~~~ ~~~~~~~~~~~
    rogue.h:732:12: note: declared here
    732 |     void (*d_func)();
        |            ^~~~~~
    make: *** [Makefile:130: daemon.o] Error 1

This was a `"feature" <https://stackoverflow.com/a/1631781>`_ of old C that modern C is trying to remove since it's unsafe.

Look at the function it's having problems with:

.. code-block:: c

    void (*d_func)();

A modern audience might agree with the compiler and think "ok that makes sense because there's no parameters listed so that means it takes 0 arguments". However, that's not what an author in 1980 would think! In their world, "the special case of void as the only item in the list specifies that the function has no parameters"  (3.5.4.3):

.. code-block:: c

    void (*foo)(void);

``d_func`` is different: `C89 <https://port70.net/%7Ensz/c/c89/c89-draft.txt>`_ calls ``d_func`` a "pointer [...] to a function with no parameter specification" (3.5.4.3). Additionally, "the empty list in a function declarator that is not part of a function definition specifies that no information about the number or types of the parameters is supplied" (3.5.4.3). Since "a function prototype is a declaration of a function that declares the types of its parameters" (3.1.2.1) and ``d_func`` does not declare the types of its parameters then ``d_func`` does not have a prototype.

During a function call: "If the expression that denotes the called function has a type that does not include a prototype, the integral promotions are performed on each argument and arguments that have type float are promoted to double. These are called the default argument promotions" (3.3.2.2).

.. note::

    "A char, a short int, or an int bit-field, or their signed or unsigned varieties, or an object that has enumeration type, may be used in an expression wherever an int or unsigned int may be used.  If an int can represent all values of the original type, the value is converted to an int; otherwise it is converted to an unsigned int. These are called the integral promotions" (3.2.1.1)

The spec in 3.3.2.2 goes on to say:

-   "If the number of arguments does not agree with the number of parameters, the behavior is undefined"
-   "If the function is defined with a type that does not include a prototype, and the types of the arguments after promotion are not compatible with those of the parameters after promotion, the behavior is undefined"
-   "If the function is defined with a type that includes a prototype, and the types of the arguments after promotion are not compatible with the types of the parameters, or if the prototype ends with an ellipsis ( ", ..." ), the behavior is undefined."

(Even at the time of C89, the spec says that "the use of function declarators with empty parentheses (not prototype-format parameter type declarators) is an obsolescent feature." (3.9.4))

Let's tie this back to Rogue. Rogue has a concept of "delayed actions":

.. code-block:: c

    extern struct delayed_action {
        int d_type;
        void (*d_func)();
        int d_arg;
        int d_time;
    } d_list[MAXDAEMONS];

There are two kinds of delayed actions: fuses and daemons.

-   A fuse perform an action once after a certain length of time elapses. It is created with ``fuse``. You can delay it with ``lengthen`` or cancel it with ``extinguish``.
-   A daemon always runs (``d_time`` is set to a special value of ``DAEMON``, which is ``-1``). It is created with ``start_daemon`` and stopped with ``kill_daemon``.

When the fuse runs out, or the daemon is processed, ``d_func(d_arg)`` is evaluated.

List of fuses:

-   ``main``: ``fuse(swander, 0, WANDERTIME, AFTER);``
-   ``rollwand``: ``fuse(swander, 0, WANDERTIME, BEFORE);``
-   ``misc``: ``fuse(nohaste, 0, rnd(4)+4, AFTER);``
-   ``wake_monster``: ``fuse(unconfuse, 0, spread(HUHDURATION), AFTER);``
-   ``quaff``: ``fuse((void(*)())turn_see, TRUE, HUHDURATION, AFTER);``
-   ``do_pot``: ``fuse(pp->pa_daemon, 0, t, AFTER);``

List of daemons:

-   ``swander``: ``start_daemon(rollwand, 0, BEFORE);``
-   ``main``: ``start_daemon(runners, 0, AFTER);``
-   ``main``: ``start_daemon(doctor, 0, AFTER);``
-   ``main``: ``start_daemon(stomach, 0, AFTER);``
-   ``quaff``: ``start_daemon(visuals, 0, BEFORE);``

Notice that the only delayed action that uses ``d_arg`` is the fuse started in ``quaff`` for ``turn_see``.

.. note::
    
    ``turn_see(FALSE)`` means that the player has X-ray vision and can see monsters. ``turn_see(TRUE)`` means that they cannot see monters through walls. To me, this is the opposite of what I would expect.

What do we do? Tell the compiler to use an older standard! If the ``CFLAGS`` environment variable is set then ``configure`` will bake the value into the Makefile::

    CFLAGS=-std=gnu89 ./configure

Curses
------

With the prior issue fixed, we now run into::

    main.c: In function ‘tstp’:
    main.c:241:11: error: invalid use of incomplete typedef ‘WINDOW’ {aka ‘struct _win_st’}
    241 |     curscr->_cury = oy;
        |           ^~
    main.c:242:11: error: invalid use of incomplete typedef ‘WINDOW’ {aka ‘struct _win_st’}
    242 |     curscr->_curx = ox;
        |           ^~

``tstp`` is the function which handles the ``SIGTSTP`` signal. ``TSTP`` is short for `terminal stop <https://en.wikipedia.org/wiki/Signal_(IPC)>`_. This signal suspends the process. It is generated by sending the ``SUSP`` character, typically via Ctrl-Z (`source <https://ftp.gnu.org/old-gnu/Manuals/glibc-2.2.3/html_node/libc_465.html>`_).

Here's the entire body of ``tstp``:

.. code-block:: c

    /*
    * tstp:
    *	Handle stop and start signals
    */

    void
    tstp(int ignored)
    {
        int y, x;
        int oy, ox;

        NOOP(ignored);

        /*
        * leave nicely
        */
        getyx(curscr, oy, ox);
        mvcur(0, COLS - 1, LINES - 1, 0);
        endwin();
        resetltchars();
        fflush(stdout);
        md_tstpsignal();

        /*
        * start back up again
        */
        md_tstpresume();
        raw();
        noecho();
        keypad(stdscr,1);
        playltchars();
        clearok(curscr, TRUE);
        wrefresh(curscr);
        getyx(curscr, y, x);
        mvcur(y, x, oy, ox);
        fflush(stdout);
        curscr->_cury = oy;
        curscr->_curx = ox;
    }

This stores some `curses <https://en.wikipedia.org/wiki/Curses_(programming_library)>`_ state before suspending and restores it after resuming. So what's the big deal?

Modern programs typically use the `ncurses <https://invisible-island.net/ncurses/>`_ implementation. By default, this is the declaration of ``WINDOW``:

.. code-block:: c

    // curses.h
    typedef struct _win_st WINDOW;

The full struct definition is hidden by a check that ``NCURSES_OPAQUE`` is false but the macro defaults to true:

.. code-block:: c

    // curses.h
    #if !NCURSES_OPAQUE

    struct _win_st
    {
	    NCURSES_SIZE_T _cury, _curx; /* current cursor position */
        // ...
    };
    #endif /* NCURSES_OPAQUE */

You can disable this by rebuilding ncurses. I'm installing to ``$HOME/local``:

.. code-block:: shell

    ./configure --disable-opaque-curses --prefix=$HOME/local
    make -j $(nproc)
    make install

Screen size
-----------

If the program doesn't seem to run, make sure your terminal is at least 80x24 characters. The game tries to print this but I think modern terminals eat up the message.

Controls
--------

Press ``?`` in game for all commands. Note that they are case sensitive (except for movement)! My notes:

*   Can quit with ``Q`` or Ctrl-C
*   ``/``: the game says "identify object". This is not the same kind of identification that you go to Deckard Cain for. It's literally "ok wtf does ``:`` represent" (it's "food" btw). It's more like "describe" or "look"
*   ``I``: "inventory" in the verb sense, i.e. to catalog. This just describes a single item of your choice in your inventory. You probably want ``i`` (lowercase) instead.
*   ``^[[`` is the Escape key
*   ``c``: call allows you to give invetory items a nickname
*   ``D``: Shows you the effects of potions/scrolls/rings/sticks found this run

Firing a bow
------------

You start with a short bow and some arrows. I think you equip the bow then throw arrows?

You can throw arrows while not wielding the bow. However, you only get the bow to-hit and damage bonus when the bow is wielded.

Heath
-----

HP regenerates over time. Pass time intentioanlly with ``.``. It takes ~19 ticks to get 1 HP. This consumes food though!

Object reference
----------------

Level details:

-   ``+``: Door
-   ``%``: stairs
-   ``|``/``-``: wall of a room
-   ``#``: passage

Items:

-   ``:``: food
-   ``*``: gold
-   ``?``: scroll

Monsters:

-   ``S``: snake
-   ``H``: hobgoblin
-   ``B``: bat
-   ``E``: emu
-   ``K``: kestrel

Misc:

-   ``@``: you

Monsters
--------

-   ``H``: hobgoblin. Hits like a truck at lower levels. 3 Exp
-   ``E``: emu. 2 Exp
-   ``K``: kestrel. Moves two spaces every turn. 3 Exp
-   ``S``: snake. Hard to hit? 3 Exp

Scrolls
-------

Scrolls are single use items. They start unidentified and the effects only become known after reading.

-   "Oh, now this scroll has a map on it": reveals part? all? of the level
-   "You feel as if somebody is watching over you": +str?
-   Teleport to a random location

Stats
-----

-   HP: Shown as ``current(max)``. Game over when 0. Starts at 12. Get more on level up.
-   Str: Shown as ``current(max)``. ???. Starts at 10. Get more on level up.
-   Exp: Shown as ``level/points``. Points are gained by killing monsters. Level up when points reaches certain thresholds.
-   Arm: Starts at 4

Level thresholds:

-   1: 0
-   2: 10 (more heatlth)
-   3: 20 (more health)

Saving and loading
------------------

``S`` saves the game to disk then quits.

To load again, pass the save file as the first arg when launching the file:

.. code-block:: shell

    ./rogue myfile.save
