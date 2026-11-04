/**
* Name: assignment3_lion_demography
* Lion demography in the Savannah (see docs/assignment3/DESIGN.md). Version 1.0: final model (all six bullets)
* (Savannah base, lion age and age_list, console age report, lion age chart, lion colour from the mean age,
* plus old lions replaced by baby lions).
*/

model assignment3_lion_demography

/* Global section: holds the parameters, age_list and lion_colour, creates the initial lions and zebras,
 * keeps age_list up to date, writes the age report, sets the lion colour and pauses the simulation at step 500. */
global {

	/* Number of lions created at the start (can be changed as a parameter). */
	int nb_lions_init <- 20;
	/* Number of zebras created at the start (can be changed as a parameter). */
	int nb_zebras_init <- 20;
	/* Age list: the current age of every lion in whole years; starts empty. */
	list<int> age_list <- [];
	/* Lion colour: red shade from the mean lion age; starts light red. */
	rgb lion_colour <- rgb(255, 150, 150);

	/* Initialisation: creates nb_lions_init lions and nb_zebras_init zebras at random positions,
	 * then puts the age of every lion into age_list. */
	init {
		create lion number: nb_lions_init;
		age_list <- lion collect each.age;
		create zebra number: nb_zebras_init;
	}

	/* Reflex update_age_list: every step replaces the old values in age_list with the current age of every lion.
	 * Runs before the lions age in the same step, so the list is one step behind. */
	reflex update_age_list {
		age_list <- lion collect each.age;
	}

	/* Reflex report: if there are lions, writes the number, min, mean and max age to the console
	 * and sets lion_colour from the mean age (light red at 0, dark red at 60 or more). */
	reflex report when: !empty(age_list) {
		float m <- mean(age_list);
		write "Step " + cycle + ": " + length(age_list) + " lions, min " + min(age_list)
			+ ", mean " + (m with_precision 1) + ", max " + max(age_list);
		float t <- min(1.0, m / 60);
		lion_colour <- rgb(int(255 - 135 * t), int(150 - 150 * t), int(150 - 150 * t));
	}

	/* Reflex stop_at_500: pauses the simulation when it reaches step 500. */
	reflex stop_at_500 when: cycle = 500 {
		do pause;
	}
}

/* Lion: a predator that walks randomly, gets older and kills every zebra within 3 m.
 * Its position is the built-in attribute 'location'. When older than 60 it is replaced by a baby lion. */
species lion skills: [moving] {

	/* Age: the lion's age in whole years, random start value between 0 and 60. */
	int age <- rnd(60);

	/* Reflex grow_older: every step the lion gets 1 year older. */
	reflex grow_older {
		age <- age + 1;
	}

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

	/* Reflex replace: when the lion is older than 60, first a baby lion (age 0) is born
	 * at the same location, then the old lion dies. */
	reflex replace when: age > 60 {
		create lion with: [age::0, location::location];
		do die;
	}

	/* Aspect base: draws the lion as a circle of size 3 with a black border,
	 * in lion_colour (red shade from the mean lion age). */
	aspect base {
		draw circle(3) color: lion_colour border: #black;
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
 * a map display, a chart of lions and zebras over time and a chart of min/mean/max lion age. */
experiment lion_demography_gui type: gui {

	/* Parameters: the user can change the number of lions and zebras before a run (sliders 0-100). */
	parameter "Number of lions" var: nb_lions_init min: 0 max: 100;
	parameter "Number of zebras" var: nb_zebras_init min: 0 max: 100;

	/* Outputs: a map display, a population chart display and a lion age chart display. */
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

		/* Display "Lion ages": min, mean and max lion age at each step (0 if there are no lions). */
		display "Lion ages" {
			chart "Lion ages" type: series x_label: "Time (steps)" y_label: "Age (years)" {
				/* Data series: youngest lion age. */
				data "Min age" value: empty(age_list) ? 0 : min(age_list) color: #orange;
				/* Data series: mean lion age. */
				data "Mean age" value: empty(age_list) ? 0 : mean(age_list) color: #red;
				/* Data series: oldest lion age. */
				data "Max age" value: empty(age_list) ? 0 : max(age_list) color: #darkred;
			}
		}
	}
}
