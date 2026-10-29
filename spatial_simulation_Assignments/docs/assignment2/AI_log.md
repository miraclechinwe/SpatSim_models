# AI log – Assignment 2 (Savannah with Claude Code)

Tool: Claude Code (Claude Opus 5.5), manual mode, rules in AGENTS.md.

1. Specification written by me before the first prompt (docs/assignment2/SPEC.md).
2. Prompt 1: create 20 zebras that walk randomly (grey triangle). Claude listed its plan and asked before creating the file. Worked on the first try. Committed.
3. Asked Claude to reorganise the folder. It offered two ways to rename; I chose git mv so the file history is kept. I reviewed the README diff before accepting.
4. Prompt 2: add 20 lions (random walk, orange circle). Claude suggested circle(1.5) for realistic scale; I rejected it and kept circle(3) as the assignment requires. Tested in GAMA: works. Committed.
5. Prompt 3: lions kill zebras within 3 m. Claude explained that the distance is measured between centres, so the kill range equals the drawn lion circle (radius 3). Tested: about 9 zebras left after 239 cycles. Committed.
Prompt 4: grassland. Claude noticed that the spec has no maximum biomass, so the map would turn fully green in 100 steps. I chose full green at 20 kg (as in my Assignment 1), no cap.
6. Prompt 4: grassland (50 x 50, biomass 0-10 kg, +0.1 kg per step). Claude noticed the spec has no maximum biomass, so the map would turn green in about 100 steps. I chose full green at 20 kg (as in my Assignment 1), no cap. Tested: works, but grey zebras are hard to see on green. Committed.
8. Prompt 6: zebra line chart (second display, title and axis labels). Tested: line drops in steps from 20 as lions catch zebras by chance. Committed.