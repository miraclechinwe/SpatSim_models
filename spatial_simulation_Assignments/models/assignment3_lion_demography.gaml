/**
* Name: assignment3_lion_demography
* Lion demography in the Savannah (see docs/assignment3/DESIGN.md). Version 0.2: Savannah base
* (lions and zebras walk, lions kill zebras, zebras eat grass, grass grows, population chart).
*/

model assignment3_lion_demography

/* Global section: holds the start parameters, creates the initial lions and zebras and pauses
 * the simulation at step 500. Later: ageing speed, age_list, the age report and the lion colour from the mean age. */
global {

	/* Number of lions created at the start (can be changed as a parameter). */
	int nb_lions_init <- 20;
	/* Number of zebras created at the start (can be changed as a parameter). */
	int nb_zebras_init <- 20;

	/* Initialisation: creates nb_lions_init lions and nb_zebras_init zebras at random positions.
	 * Later: also fills age_list with the lions' ages. */
	init {
		create lion number: nb_lions_init;
		create zebra number: nb_zebras_init;
	}

	/* Reflex stop_at_500: pauses the simulation when it reaches step 500. */
	reflex stop_at_500 when: cycle = 500 {
		do pause;
	}
}

/* Lion: a predator that walks randomly and kills every zebra within 3 m.
 * Its position is the built-in attribute 'location'. Later: age, ageing and replacement by a baby lion. */
species lion skills: [moving] {

	/* Reflex move: every step the lion walks in a random direction. */
	reflex move {
		do wander;
	}

	/* Reflex hunt: every step the lion kills every zebra within 3 m of it
	 * (distance measured between the centres). */
	reflex hunt {
		ask zebra at_distance 3 {
			do die;
		}
	}

	/* Aspect base: draws the lion as a red circle of size 3 with a black border.
	 * Later: the red shade will come from the mean age. */
	aspect base {
		draw circle(3) color: #red border: #black;
	}
}

/* Zebra: a grazing animal that walks randomly and eats grass.
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

/* Grassland: a 50 x 50 grid of grass cells. The world is 100 x 100 m by default,
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

/* GUI experiment: runs the model with parameters for the number of lions and zebras,
 * a map display and a chart of lions and zebras over time. Later: the chart of min/mean/max lion age. */
experiment lion_demography_gui type: gui {

	/* Parameters: the user can change the number of lions and zebras before a run (sliders 0-100). */
	parameter "Number of lions" var: nb_lions_init min: 0 max: 100;
	parameter "Number of zebras" var: nb_zebras_init min: 0 max: 100;

	/* Outputs: a map display and a population chart display. */
	output {
		/* Display map: the grass grid with the zebras and lions on top. */
		display map {
			grid grassland;
			species zebra aspect: base;
			species lion aspect: base;
		}

		/* Display population_chart: line chart of the number of lions and zebras alive at each step. */
		display population_chart {
			chart "Lions and zebras alive over time" type: series x_label: "Time (steps)" y_label: "Number of animals" {
				/* Data series: number of lion agents alive (red, like on the map). */
				data "Lions alive" value: length(lion) color: #red;
				/* Data series: number of zebra agents alive (grey, like on the map). */
				data "Zebras alive" value: length(zebra) color: #grey;
			}
		}
	}
}
