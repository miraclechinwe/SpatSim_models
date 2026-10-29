/**
* Name: savanna_ai
* Savannah model (see SPEC.md). Feature 1: zebras walking randomly. Feature 2: lions walking randomly. Feature 3: lions kill zebras within 3 m.
*/

model savanna_ai

/* Global section: sets up the world and creates the initial agents. */
global {

	/* Initialisation: creates 20 zebras and 20 lions at random positions. */
	init {
		create zebra number: 20;
		create lion number: 20;
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

/* Lion: a predator that walks randomly around the savannah and kills nearby zebras.
 * Its position is the built-in attribute 'location'. */
species lion skills: [moving] {

	/* Reflex move: every step the lion walks in a random direction. */
	reflex move {
		do wander;
	}

	/* Reflex hunt: every step the lion kills every zebra within 3 m of it. */
	reflex hunt {
		ask zebra at_distance 3 {
			do die;
		}
	}

	/* Aspect base: draws the lion as an orange circle of size 3 with a black border. */
	aspect base {
		draw circle(3) color: #orange border: #black;
	}
}

/* GUI experiment: runs the model with a map display. */
experiment savanna_gui type: gui {

	/* Outputs: one display showing the zebras and the lions. */
	output {
		display map {
			species zebra aspect: base;
			species lion aspect: base;
		}
	}
}
