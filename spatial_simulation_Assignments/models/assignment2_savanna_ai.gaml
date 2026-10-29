/**
* Name: savanna_ai
* Savannah model (see SPEC.md). Feature 1: zebras walking randomly.
*/

model savanna_ai

/* Global section: sets up the world and creates the initial agents. */
global {

	/* Initialisation: creates 20 zebras at random positions. */
	init {
		create zebra number: 20;
	}
}

/* Zebra: a grazing animal that walks randomly around the savannah.
 * Its position is the built-in attribute 'location'. */
species zebra skills: [moving] {

	/* Reflex move: every step the zebra walks in a random direction. */
	reflex move {
		do wander;
	}

	/* Aspect base: draws the zebra as a grey triangle of size 2. */
	aspect base {
		draw triangle(2) color: #grey;
	}
}

/* GUI experiment: runs the model with a map display. */
experiment savanna_gui type: gui {

	/* Outputs: one display showing the zebras. */
	output {
		display map {
			species zebra aspect: base;
		}
	}
}
