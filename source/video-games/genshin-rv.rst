Understanding Roll Value (RV)
=============================

Artifacts have 4 substats. At level 4/8/12/16/20:

- less than 4 substats? roll a random* substat at 70/80/90/100% of its max roll (max roll varies by stat)
- otherwise increase a random* substat by either 70/80/90/100% of its max roll (max roll varies by stat)

max rolls for each stat:

- crit rate: 3.9%
- crit dmg: 7.8%
- atk%: 5.8%
- hp%: 5.8
- er: 6.5%
- em: 23
- atk: 19
- def: 23
- def%: 7.3
- HP: 299

The random substat is weighted, see the wiki: https://genshin-impact.fandom.com/wiki/Artifact/Distribution

The best artifact has 900% RV:

- 5* artifacts with 4 substats each at 100% RV: 400% RV
- You get 5 more rolls (4/8/12/16/20) at 100% RV: +500% RV

The worst artifact has 560% RV*:

- 5* artifact with with 3 substats at 70% RV: 210% RV
- You get 5 more rolls (4/8/12/16/20) at 70% RV: +350% RV

The absolute garbage artifact can have effectively 0% RV if it only rolls stats that you don't care about. Typically for a carry this is flat ATK, flat DEF, DEF%, flat HP, HP%. (Some characters kinda care about these stats, like Noelle awants DEF%, Hu Tao can use HP%, etc)

An example
----------

Look at this:

    Moment of Judgement (Sands, Marechaussee Hunter)

    Main stat: HP%

    Substats:

    - HP+299
    - ATK+16
    - CRIT Rate+3.1%

This is a 5-star artifact at level 0 that rolled with 3 substats. Theoretically, this can have 300% RV with 500% max. However, what we see:

- HP+299: 100% RV
- ATK+16: 80% RV
- CRIT Rate+3.1%: 80% RV

That means this starts with 260% RV with 760% RV max.

However, if I want this for a typical carry, I don't care about flat HP and flat ATK so it effectively has 80% RV. Since it's missing 1 substat, there's two outcomes as I level:

#. It rolls something that I care about (like CRIT Dmg): the max RV is 580%. This requires all subsequent rolls to be either CRIT Rate or the stat I care about. This is pretty low probability.
#. It rolls something that I don't (like DEF%); the max RV is 480%. This requires all subsequent rolls to be CRIT Rate. This is pretty low probability.

The probability of rolling CRIT DMG is 3 / (6 + 4 + 4 + 4 + 4 + 3) = 3 / 25 = 12%

.. note:: See https://genshin-impact.fandom.com/wiki/Artifact/Distribution

You can calculuate the probably of the first outcome using Genshin Optimizer. It says <1% of hitting even 70% RV on just CRIT Rate and CRIT Dmg 5 times in a row.

The probability of rolling CRIT Rate again is 