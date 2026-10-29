# Step 3 – Comparison: Assignment 1 (hand-written) vs Assignment 2 (Claude Code)



## Same

- 20 zebras and 20 lions, random walk (do wander)

- Hunting: ask zebra at\_distance 3 { do die; } (identical)

- Lion: orange circle(3), black border; zebra: grey triangle(2)

- Grid 50 x 50, biomass rnd(10.0), +0.1 kg per step

- Pause at cycle 500 (identical)



## Different

- Names: aspect default/base, reflex walk/move, experiment play/savanna\_gui

- Claude added parameters for the number of zebras and lions (sliders 0-200)

- Claude's zebras had no black border

- Grass colour: mine is updated in reflex grow (after growing), Claude's in update: (before growing)

- Comments: mine short //, Claude's longer /\* \*/ blocks

- Chart: mine styled with fixed y-axis 0-21, Claude's plain with automatic y-axis



## Better

- Claude: parameters, detailed comments, automatic y-axis (my fixed 0-21 would cut off the line with more than 21 zebras)

- Mine: nicer chart design, zebra border (better visibility), colour always up to date



## Wrong (semantic errors) and fixes

1. Chart label "1 step = 1 hour" was not true: the model never sets the time step (GAMA default = 1 s). Fixed: label "Time (steps)"; spec updated.

2. Grass colour is one step behind the biomass (0.1 kg, not visible). Not fixed.

3. Header comment pointed to SPEC.md, which had moved to docs/assignment2/. Fixed.

4. Added a black border to the zebras for visibility. Fixed.

