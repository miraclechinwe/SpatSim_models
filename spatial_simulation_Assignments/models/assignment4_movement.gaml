/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 1.1: skeleton only.
*/

model assignment4_movement

/* Global section: will create the cows, sheep and goats in init. */
global {
	/* Init: runs once at the start; agents will be created here. */
	init {
	}
}

/* Cow species: will do a correlated random walk with wander. */
species cow skills: [moving] {
}

/* Sheep species: will move towards the south with move. */
species sheep skills: [moving] {
}

/* Goat species: will walk towards the origin with goto. */
species goat skills: [moving] {
}

/* GUI experiment: will show one map display with all agents and their action neighbourhoods. */
experiment main type: gui {
	output {
		/* Map display: species layers will be added here. */
		display map {
		}
	}
}
