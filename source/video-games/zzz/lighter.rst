Lighter
=======

Fire, Stun

Summary:

-   15% Ice/Fire RES Shred for 30s
-   +3s to Stun duration
-   +75% Ice/Fire DMG (at 270 Impact; Additional Ability)
-   +30% CRIT DMG (King of the Summit 4PC)
-   +30% CRIT DMG for Fire/Ice DMG (Blazing Laurel S1)
-   Decent personal damage

.. note:: Need 270 Impact for full Additional Ability effect.

    Compared to other stats, there are few sources of Impact. Out of combat:

    -   137 at Level 60, Core F
    -   +18% from S-Rank W-Engine main stat
    -   +6% from Shockstar Disco 2PC
    -   +18% from Impact Slot 6:

    With 137 + 42%, Agent Base Stats page should show ``194`` (``floor(137 * (1 + 0.18 + 0.18 + 0.06)) = floor(194.54) = 194``). This is currently his max Impact out of combat.

    In combat:

    -   +20% from Core F Passive Morale consumption
    -   +25% from S1 Blazing Laurel W-Engine effect

    137 + 97% = 269 (``floor(137 * (1 + 0.18 + 0.18 + 0.06 + 0.2 + 0.25)) = floor(269.89) = 269``)

Core Passive:

-   15% Ice/Fire RES Shred for 30s
-   +3s to Stun duration

Additional Ability (Attack, Sons of Calydon)

-   +25% Ice/Fire DMG 
-   +50% Ice/Fire DMG (270 Impact)

.. note:: "Every 10 Impact over 170 increases Elation stack effect by 0.25%" can be modeled as:

    ``+75% Fire/Ice DMG = 20 Elation stacks * (1.25% base + 0.25% * max(floor((x - 170) / 10), 0)) Fire/Ice DMG per stack`` where ``x`` is Impact.

    Solve for ``x``.

Drive Disks:

-   4PC King of the Summit: Should be the default since it gives +30% CRIT DMG
-   2PC Shockstar Disco: Only source of Impact%. 6% of 137 is 8.22. This is unfortunately <10% but could still help you to hit the next breakpoint on the Additional Ability.
-   2PC ER: More EX Special Attacks (source of Daze)
-   2PC Woodpecker Electro: If you need the 8% CRIT Rate to hit the King of the Summit 50% CRIT Rate threshold.

Synergies:

-   Any Fire or Ice character: Evelyn, Manato, Miyabi, Solider 11, Ellen, Hugo, ...

    Some characters don't activate his Additional Ability: Miyabi (Anomaly), Yidhari (Rupture), Manato (Rupture), Banyue (Rupture), etc.. The easiest way to fix this is to run Lucy; Orphie & Magus is another option. This comes at the opportunity cost of running another S-Rank Support Agent: Miyabi likes Yuzuha, while the Rupture Agents like Lucia.

    Push comes to shove, Lighter without his Additional Ability might still be a better choice than another S-Rank agent (provided that you work around enemy Stun). I suggest to "fuck around and find out".
