# Assignment 5 – Verification dashboard (model design)

## Purpose
Verify the "On the move" model (Assignment 4, v2.3) with a dashboard: check that cows, sheep and goats move as designed.

## Base model
Copy of models/assignment4_movement.gaml (v2.3), saved as models/assignment5_dashboard.gaml. Assignment 4 stays unchanged.
- 30 x 30 m field
- 5 cows: correlated random walk, speed 2, amplitude 90 degrees
- 3 sheep: move south (heading 90), speed 1
- 2 goats: goto the origin {0,0}, speed 0.5

## New variables
- Every animal: total_distance (m), increased every step by the distance between its old and new location
- Global: cow_turns, a list of every cow direction change (degrees, between -180 and +180), new values added every step
- Global: sheep_first_step and cow_first_step, the mean distance of sheep and cows in the first time step (recorded at cycle 1)

## Dashboard (layout #split)
- Map with all animals and their action areas (as in Assignment 4)
- Monitor 1: number of sheep in the south (within one step of the bottom edge), of 3
- Monitor 2: number of goats at the origin (closer than 0.01 m to {0,0}), of 2
- Time series: mean total distance travelled by the goats
- Scatterplot: mean distance of sheep (x) vs. cows (y) in the first time step
- Histogram: cow direction changes in 5 degree bins, from -180 to +180 (72 bins)

## End of the simulation
- When all sheep are in the south and all goats are at the origin:
  save a summary and all cow direction changes as CSV files in docs/assignment5, then pause

## Expected results (sketched before coding)
- Goats: mean total distance rises 0.5 m per step, 0.25 m per step after the first goat arrives, flat after both arrive; final value about 23 m (max 42 m)
- Scatterplot: one point at (1, 2), slightly lower or left only if an animal starts at the field edge
- Histogram: about flat between -45 and +45 degrees (18 bars of 5 degrees, about 15 per bar), empty outside
- Monitors: sheep 0 to 3 within 30 steps, goats 0 to 2 by about step 60; then save and pause
