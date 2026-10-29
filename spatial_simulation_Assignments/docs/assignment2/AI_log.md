# AI log – Assignment 2 (Savannah with Claude Code)

Tool: Claude Code (Claude Opus 5.5), manual mode, rules in AGENTS.md.

1. Specification written by me before the first prompt (docs/assignment2/SPEC.md).
2. Prompt 1: create 20 zebras that walk randomly (grey triangle). Claude listed its plan and asked before creating the file. Worked on the first try. Committed.
3. Asked Claude to reorganise the folder. It offered two ways to rename; I chose git mv so the file history is kept. I reviewed the README diff before accepting.
4. Prompt 2: add 20 lions (random walk, orange circle). Claude suggested circle(1.5) for realistic scale; I rejected it and kept circle(3) as the assignment requires. Tested in GAMA: works. Committed.
5. Prompt 3: lions kill zebras within 3 m. Claude explained that the distance is measured between centres, so the kill range equals the drawn lion circle (radius 3). Tested: about 9 zebras left after 239 cycles. Committed.