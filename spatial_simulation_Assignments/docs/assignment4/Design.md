# Assignment 4 – Movement and action neighbourhoods (model design)

## Purpose
Show the three movement actions of the moving skill (wander, move, goto) and visualise each agent's action neighbourhood: the space where it can potentially be in the next time step.

## Agents
- 5 cows, brown: correlated random walk, do wander amplitude: 90.0 speed: 2
- 3 sheep, black: all move towards the south, do move heading: 90 speed: 1 (east = heading 0, so south = 90)
- 2 goats, yellow: slowly walk towards the origin, do goto target: {0,0} speed: 0.5

## Action neighbourhood
- Every agent has a variable geometry action_area
- A reflex updates action_area every step, after the agent has moved, so it shows where the agent can be in the next step
- Cow: circle(speed) intersection cone(heading - 45, heading + 45), a slice of a circle
- Sheep: a line from its location to its location + {0, 1}, one step south
- Goat: line from its location to {0,0} intersection circle(speed), one step towards the origin

## Visualisation
- Each species has two aspects: default (the animal) and action_area (its action neighbourhood)
- The experiment draws both aspects on top of each other, the action_area with transparency 0.5

## Output
- One map display with all agents and their action neighbourhoods