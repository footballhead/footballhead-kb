===
ZZZ
===

Yes, I play ZZZ. No, I will not be taking further questions.

.. toctree::
    :maxdepth: 2

    archetypes.rst
    drive-disks.rst
    agents.rst
    builds.rst

-----
Tools
-----

`Zenless Optimizer <https://frzyc.github.io/zenless-optimizer/>`_ is still very much in development as is not as easy to use as Genshin Optimizer.

--------
Glossary
--------

.. glossary::

    Initial Max HP
        HP shown on the Agent Base Stats screen.

        .. math::

            Initial Max HP = \left\lceil Base Max HP \times (1 + \frac{\sum HP\% Bonus}{100\%}) + \sum HP Bonus \right\rceil

        where:

        -   *Base Max HP* is the HP at Level 60, Core F. You can find this by removing your W-Engine and all Drive Disks, or subtracting the HP from the Stat Bonuses modal on the Agent Equipment screen from the HP on the Agent Base Stats screen. E.g. Lucia is 8477
        -   *HP% Bonus* includes:
        
            -   Core Sill Enhancement (e.g. Zhao is 18% total)
            -   W-Engine Advanced Stat (e.g. Half-Sugar Bunny is 30%)
            -   2PC/4PC Drive Disk Set Effects (e.g. Yunkai Tales is 10%)
            -   Drive Disk Main Stats (e.g. Slot 4/5/6 is 30% each)
            -   Drive Disk Sub-Stats (3% for each roll)
        
        -   *HP Bonus* includes:
        
            -   Drive Disk Main Stat (e.g. Slot 1 is 2200)
            -   Drive Disk Sub-Stats (112 for each roll)

        Notice that the HP% bonuses is applied before the HP bonus!

        For example, for my Lucia:

        -   *Base Max HP* is 8477
        -   *HP% Bonus* includes:

            -   30% from Dreamlit Hearth
            -   10% from Yunkui Tales 2PC
            -   6% from slot 1 Sub-Stats (2 rolls)
            -   9% from slot 2 Sub-Stats (3 rolls)
            -   6% from slot 4 Sub-Stats (2 rolls)
            -   30% from slot 4 Main Stat
            -   30% from slot 5 Main Stat
            -   30% from slot 6 Main Stat
        
        -   *HP Bonus* includes:

            -   2200 from slot 1 Main Stat
            -   224 from slot 3 Sub-Stats (2 rolls)
            -   224 from slot 4 Sub-Stats (2 rolls)
            -   224 from slot 5 Sub-Stats (2 rolls)

        .. math::

            \begin{array}{lcl}
            Initial Max HP & = & \left\lceil Base Max HP \times (1 + \frac{\sum HP\% Bonus}{100\%}) + \sum HP Bonus \right\rceil \\
            & = & \left\lceil 8477 \times (1 + \frac{30\%+10\%+6\%+9\%+6\%+30\%+30\%+30\%}{100\%}) + (2200 + 244 + 244 + 244) \right\rceil \\
            & = & \left\lceil 8477 \times (1 + \frac{151\%}{100\%}) + 2872 \right\rceil \\
            & = & \left\lceil 8477 \times 2.51 + 2872 \right\rceil \\
            & = & 24150
            \end{array}

    W-Engine
        Analogous to a weapon in other videogames (Genshin, etc). Agents can have up to 1 W-Engine. Each W-Engine has an ATK value, main stat, and effect. The set effect get better with refinement. A W-Engine starts at refinement 1. You can sacrifice one W-Engine of the same name to increase the refiment by 1. Max refinement is 5. Shorthard is PX where X is the refinement.

-   Drive Disks: Analogous to artifacts in Genshin, or equipment in other video games. Agents have 6 Drive Disks slots that can each have up to 1 Drive Disk of the corresponding type. Each Drive Disk has a main stat and up to 4 unique substats. Drive Disks have set effects when an Agent has equipped 2+ pieces (shorthand is 2PC) or 4+ pieces (shorthand is 4PC)

-   Agent: Playable avatars

-   Squad: Team of 1-3 agents

-   Core Skill

-   Basic Attack

-   Dodge: Attempt to evade enemy attack. Start with 2 dodges; dodges regenerate over time. Successful dodges trigger Perfect Dodge.

-   Perfect Dodge: Use Dodge at the right time in response to red/yellow flash. Ignores enemy attack. Press Bassic Attack to perform Dodge Counter

-   Dodge Counter: Press Basic attack right after Perfect Dodge.

-   Perfect Assist: Use Assist at the right time during a yellow flash. One of two effects based on Agent: Defensive and Evasive. Requires Assist Points. Consumes 1 or 2 depending on enemy attack.

-   Assist Points: Required to perform Perfect Assist. Starts at 6. Gain 3 when enemy is stunned. Some agents may consume as part of their kit (e.g. Pulchra, Caesar). Yellow flashes become red if insufficient Assist Points.

-   Quick Assist: Use Assist when a Quick Assist prompt is a active. Prompts when agent is launched. Some Agents trigger prompt as part of their kit (e.g. Astra).

-   Defensive Assist: Perform Perfect Assist with agents with a Defensive Assist. Parries the attack

-   Evasive Assist: Perform Perfect Assist with agents with a Defensive Assist. Dodges the attack and enters Vital View.

-   Vital View: slow mo for x seconds

-   Assist Follow-up: Use Basic attack right after Perfect Assist is performed.

-   Chain Attack

-   Ultimate

-   Stun

-   Daze

-   Impact

-   Sheer Force: Stat that determines Rupture agent Sheer DMG. 30% of Agent ATK is converted to Sheer Force.

-   Sheer DMG: Damage done by Rupture agents. Ignores enemy defense, making Rupture agents more effective against enemies with inherently high DEF or with Miasmic Shield. This makes PEN and DEF shred (e.g. Nicole) useless. Calculated based on Sheer Force. Current Rupture agents: Yixuan (Auric Ink, a.k.a Ether), Yidhari (Ice), Manato (Fire), Banyu (Fire)
