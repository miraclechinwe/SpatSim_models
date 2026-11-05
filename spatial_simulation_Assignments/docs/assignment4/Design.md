# Assignment 4 – Movement actions and action neighbourhood (model design)

## Purpose
Show the three movement actions of the moving skill (wander, move, goto) and visualise each agent's action neighbourhood (where it can go in the next step).

## Agents
- 5 cows, brown: correlated random walk with do wander, speed 2, amplitude 90 degrees
- 3 sheep, black: all move towards the south with do move, speed 1 (east = heading 0, so south = heading 90)
- 2 goats, yellow: slowly walk towards the origin {0,0} with do goto, speed 0.5

## Action neighbourhood (visualisation)
- cow: circle with radius = speed around the cow
- sheep: line of length = speed towards the south
- goat: line from the goat to the origin

## Output
- one map display with all agents and their action neighbourhoods
