/**
* Name: savanna_ai
* Savannah model (see docs/assignment2/SPEC.md). Feature 1: zebras walking randomly. Feature 2: lions walking randomly. Feature 3: lions kill zebras within 3 m. Feature 4: grass grid with growing biomass. Feature 5: pauses automatically at step 500. Feature 6: line chart of zebras alive. Feature 7: number of zebras and lions as parameters. Feature 8: zebras eat grass. Feature 9: lions have energy and starve. Feature 10: chart shows zebras and lions alive.
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

/* Zebra: a grazing animal that walks randomly around the savannah and eats grass.
 * Its position is the built-in attribute 'location'. */
species zebra skills: [moving] {

	/* Reflex move: every step the zebra walks in a random direction. */
	reflex move {
		do wander;
	}

	/* Reflex eat: every step the zebra eats 1 kg of grass from the cell it stands on,
	 * or what is left if the cell has less than 1 kg. */
	reflex eat {
		ask grassland(location) {
			biomass <- max(0.0, biomass - 1.0);
		}
	}

	/* Aspect base: draws the zebra as a grey triangle of size 2 with a black border. */
	aspect base {
		draw triangle(2) color: #grey border: #black;
	}
}

/* Lion: a predator that walks randomly around the savannah, kills and eats nearby zebras,
 * and dies when its energy runs out.
 * Its position is the built-in attribute 'location'. */
species lion skills: [moving] {

	/* Energy: the lion's energy level; starts at 10, the lion dies when it reaches 0. */
	float energy <- 10.0;

	/* Reflex move: every step the lion walks in a random direction and loses 0.1 energy. */
	reflex move {
		do wander;
		energy <- energy - 0.1;
	}

	/* Reflex hunt: every step the lion kills and eats every zebra within 3 m of it,
	 * gaining 5 energy for each. */
	reflex hunt {
		list<zebra> prey <- zebra at_distance 3;
		energy <- energy + 5 * length(prey);
		ask prey {
			do die;
		}
	}

	/* Reflex starve: the lion dies when its energy reaches 0. */
	reflex starve when: energy <= 0 {
		do die;
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

/* GUI experiment: runs the model with parameters for the number of zebras and lions, a map display and a chart of zebras and lions. */
experiment savanna_gui type: gui {

	/* Parameters: the user can change the number of zebras and lions before a run. */
	parameter "Number of zebras" var: nb_zebras_init min: 0 max: 200;
	parameter "Number of lions" var: nb_lions_init min: 0 max: 200;

	/* Outputs: two displays: a map of the grass, the zebras and the lions, and a line chart of zebras and lions alive. */
	output {
		display map {
			grid grassland;
			species zebra aspect: base;
			species lion aspect: base;
		}

		/* Display population_chart: line chart of the number of zebras and lions alive at each step. */
		display population_chart {
			chart "Zebras and lions alive over time" type: series x_label: "Time (steps)" y_label: "Number of animals" {
				/* Data series: the number of zebra agents still alive (grey, like on the map). */
				data "Zebras alive" value: length(zebra) color: #grey;
				/* Data series: the number of lion agents still alive (orange, like on the map). */
				data "Lions alive" value: length(lion) color: #orange;
			}
		}
	}
}
