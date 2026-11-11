# Assignment 4 – Movement and action neighbourhoods (model design)

## Purpose
Show the three movement actions of the moving skill (wander, move, goto) and visualise each agent's action neighbourhood: the space where it can potentially be in the next time step.

## World
- A 30 x 30 m field (small, so the action neighbourhoods are easy to see), light green background

## Agents
- 5 cows, brown: speed 2; correlated random walk with do wander amplitude: 90.0 (at most 45 degrees left or right)
- 3 sheep, black: speed 1, heading 90 (east = 0, so south = 90); all walk south with do move
- 2 goats, yellow: speed 0.5; slowly walk to the origin {0,0} (top left) with do goto

## Action neighbourhood
- Every species has a variable geometry action_area
- A reflex updates action_area every step, after the agent has moved, so it shows where the agent can be in the next step
- Cow: circle(speed) intersection cone(heading - 45, heading + 45), a slice of a circle
- Sheep: line from its location to its location + {0, speed}, one step south
- Goat: line from its location to {0,0} intersection circle(speed), one step towards the origin; nothing is drawn once it has arrived

## Visualisation
- Each species has two aspects: default (the animal as a small circle in its colour) and area (its action neighbourhood in goldenrod; lines drawn 0.3 m thick so they are visible)
- The display draws the area aspect first with transparency 0.5, then the default aspect on top

## Output
- One map display with all agents and their action neighbourhoods