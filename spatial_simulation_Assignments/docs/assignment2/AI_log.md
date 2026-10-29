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
9. Prompt 7: parameters for the number of lions and zebras (sliders with limits). Tested with 51 zebras: the chart starts at 51. Committed and tagged v0.1.
10. Step 3 – Compare: I compared both versions line by line (see COMPARE.md). I found a semantic error from the AI: the chart label claimed "1 step = 1 hour", but the time step was never set. I asked Claude to fix it, plus the zebra border and an outdated comment.
11. Step 4 – Extension 1: zebras eat 1 kg of grass per step from their cell. Tested: sandy patches appear where zebras walk. Committed.
12. Step 4 – Extension 2: lion energy (start 10, -0.1 per step, +5 per zebra, dies at 0). Claude predicted most lions would starve between step 100 and 200; tested: at step 182 only 1 lion was left and 14 zebras survived. Committed.
13. Step 4 – Extension 3: chart with zebras (grey) and lions (orange), display renamed to population_chart. Result: all lions that never ate starved at exactly step 100 (20 -> 11). Committed and tagged v0.2.