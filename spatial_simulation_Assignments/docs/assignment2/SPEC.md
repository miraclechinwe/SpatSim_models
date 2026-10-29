# Savannah model – specification



## Purpose

How does the number of zebras change over time when lions hunt them

in a savannah with growing grass?



## Initialisation

- 20 zebras and 20 lions at random positions

- Every grass cell gets a random biomass between 0 and 10 kg



## Agents

Lion

- Attributes: position

- Behaviour: walks randomly every step; kills every zebra within 3 m

- Look: orange circle, size 3



Zebra

- Attributes: position

- Behaviour: walks randomly every step

- Look: grey triangle, size 2



## Environment

- Cellular automaton: grid of 50 x 50 cells

- World: 100 x 100 m, so one cell = 2 x 2 m

- Cell attribute: biomass (kg of grass), random start 0-10 kg

- Grass grows 0.1 kg per step (linear growth)

- Colour: sandy = little grass, green = much grass



## Time

- One step = one simulation cycle (no real-time unit set)

- The simulation pauses automatically after 500 steps



## Inputs & outputs

- Parameters: number of lions, number of zebras

- Outputs: map (grass, zebras, lions) and a line chart of zebras alive



## Extension (step 4)

- Zebras eat grass: every step, each zebra eats 1 kg of biomass from the cell it stands on (or what is left if less than 1 kg)

- Lions have energy: start with 10, lose 0.1 per step (moving), gain 5 per zebra eaten, die when energy reaches 0

- Chart: also show the number of lions alive



## Extras (bonus, added after v0.1)

- Lions and zebras are drawn as simple animal symbols

  (lion: orange, zebra: grey), instead of circle and triangle

- When a lion kills a zebra, small red blood dots appear at that

  spot and fade away after 10 steps

