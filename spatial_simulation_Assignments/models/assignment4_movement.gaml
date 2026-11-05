/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 0.1: skeleton only.
*/

model assignment4_movement

/* Global section: will create 5 cows, 3 sheep and 2 goats in init. */
global {
	init {
	}
}

/* Cow species: will do a correlated random walk with wander (speed 2, amplitude 90) and draw its circle neighbourhood. */
species cow skills: [moving] {
}

/* Sheep species: will move towards the south with move (speed 1, heading 90) and draw its line neighbourhood. */
species sheep skills: [moving] {
}

/* Goat species: will walk towards {0,0} with goto (speed 0.5) and draw its line to the origin. */
species goat skills: [moving] {
}

/* GUI experiment: will show one map display with all agents and their action neighbourhoods. */
experiment main type: gui {
	output {
		display map {
		}
	}
}
