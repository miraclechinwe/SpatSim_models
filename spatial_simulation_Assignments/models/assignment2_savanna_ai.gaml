/**
* Name: savanna_ai
* Savannah model (see SPEC.md). Feature 1: zebras walking randomly. Feature 2: lions walking randomly. Feature 3: lions kill zebras within 3 m. Feature 4: grass grid with growing biomass. Feature 5: pauses automatically at step 500. Feature 6: line chart of zebras alive. Feature 7: number of zebras and lions as parameters.
*/

model savanna_ai

/* Global section: holds the start parameters, sets up the world, creates the initial agents and pauses the simulation at step 500. */
global {

	/* Number of zebras created at the start (can be changed as a parameter). */
	int nb_zebras_init <- 20;
	/* Number of lions created at the start (can be changed as a parameter). */
	int nb_lions_init <- 20;

	/* Initialisation: creates nb_zebras_init zebras and nb_lions_init lions at random positions. */
	init {
		create zebra number: nb_zebras_init;
		create lion number: nb_lions_init;
	}

	/* Reflex stop_at_500: pauses the simulation when it reaches step 500. */
	reflex stop_at_500 when: cycle = 500 {
		do pause;
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

/* GUI experiment: runs the model with parameters for the number of zebras and lions, a map display and a zebra chart. */
experiment savanna_gui type: gui {

	/* Parameters: the user can change the number of zebras and lions before a run. */
	parameter "Number of zebras" var: nb_zebras_init min: 0 max: 200;
	parameter "Number of lions" var: nb_lions_init min: 0 max: 200;

	/* Outputs: two displays: a map of the grass, the zebras and the lions, and a line chart of zebras alive. */
	output {
		display map {
			grid grassland;
			species zebra aspect: base;
			species lion aspect: base;
		}

		/* Display zebra_chart: line chart of the number of zebras alive at each step. */
		display zebra_chart {
			chart "Zebras alive over time" type: series x_label: "Time (steps, 1 step = 1 hour)" y_label: "Number of zebras" {
				/* Data series: the number of zebra agents still alive. */
				data "Zebras alive" value: length(zebra);
			}
		}
	}
}
