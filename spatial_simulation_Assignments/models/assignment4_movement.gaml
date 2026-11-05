/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 0.1: skeleton only.
*/

model assignment4_movement

/* Global section: creates 5 cows, 3 sheep and 2 goats in init. */
global {
	/* Init: runs once at the start and creates the agents. */
	init {
		create cow number: 5;
		create sheep number: 3;
		create goat number: 2;
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

/* Sheep species: moves straight towards the south with move (speed 1, heading 90) and draws its line neighbourhood. */
species sheep skills: [moving] {
	/* Reflex move: every step the sheep moves 1 m towards the south (heading 90, because east = 0). */
	reflex move {
		do move heading: 90.0 speed: 1.0;
	}
	/* Aspect base: the sheep as a black filled circle and its action neighbourhood as a black line 1 m (= its speed) towards the south. */
	aspect base {
		draw circle(1) color: #black;
		draw line([location, location + {0, 1}]) color: #black;
	}
}

/* Goat species: walks slowly towards the origin {0,0} with goto (speed 0.5) and draws its line to the origin. */
species goat skills: [moving] {
	/* Reflex move: every step the goat walks 0.5 m straight towards the origin {0,0}. */
	reflex move {
		do goto target: {0, 0} speed: 0.5;
	}
	/* Aspect base: the goat as a yellow filled circle and its action neighbourhood as a yellow line from the goat to the origin. */
	aspect base {
		draw circle(1) color: #yellow;
		draw line([location, {0, 0}]) color: #yellow;
	}
}

/* GUI experiment: will show one map display with all agents and their action neighbourhoods. */
experiment main type: gui {
	output {
		display map {
			species cow aspect: base;
			species sheep aspect: base;
			species goat aspect: base;
		}
	}
}
