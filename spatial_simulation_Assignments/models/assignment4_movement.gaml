/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 0.1: skeleton only.
*/

model assignment4_movement

/* Global section: creates 5 cows in init (sheep and goats will be added later). */
global {
	/* Init: runs once at the start and creates the agents. */
	init {
		create cow number: 5;
	}
}

/* Cow species: does a correlated random walk with wander (speed 2, amplitude 90) and draws its circle neighbourhood. */
species cow skills: [moving] {
	/* Reflex move: every step the cow wanders with speed 2 and turns at most 90 degrees from its current heading. */
	reflex move {
		do wander speed: 2.0 amplitude: 90.0;
	}
	/* Aspect base: the cow as a brown filled circle and its action neighbourhood as a brown outline circle with radius 2 (= its speed). */
	aspect base {
		draw circle(1) color: #brown;
		draw circle(2) color: #brown wireframe: true;
	}
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
			species cow aspect: base;
		}
	}
}
