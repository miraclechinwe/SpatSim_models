/**
* Name: savanna_ai
* Savannah model (see SPEC.md). Feature 1: zebras walking randomly. Feature 2: lions walking randomly. Feature 3: lions kill zebras within 3 m. Feature 4: grass grid with growing biomass.
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

/* Grassland: a 50 x 50 grid of grass cells. The world is 100 x 100 m,
 * so each cell is 2 x 2 m. */
grid grassland width: 50 height: 50 {

	/* Biomass: kg of grass in the cell, random start value between 0 and 10 kg. */
	float biomass <- rnd(10.0);

	/* Color: shows the biomass, from sandy (0 kg) to green (20 kg or more).
	 * Recalculated every step from the current biomass. */
	rgb color <- rgb(int(230 - 190 * min(1.0, biomass / 20.0)), int(210 - 50 * min(1.0, biomass / 20.0)), int(150 - 110 * min(1.0, biomass / 20.0)))
		update: rgb(int(230 - 190 * min(1.0, biomass / 20.0)), int(210 - 50 * min(1.0, biomass / 20.0)), int(150 - 110 * min(1.0, biomass / 20.0)));

	/* Reflex grow: every step the grass grows by 0.1 kg (linear growth, no maximum). */
	reflex grow {
		biomass <- biomass + 0.1;
	}
}

/* GUI experiment: runs the model with a map display. */
experiment savanna_gui type: gui {

	/* Outputs: one display showing the grass, the zebras and the lions. */
	output {
		display map {
			grid grassland;
			species zebra aspect: base;
			species lion aspect: base;
		}
	}
}
