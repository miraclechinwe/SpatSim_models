/**
* Name: assignment3_lion_demography
* Lion demography in the Savannah (see docs/assignment3/DESIGN.md). Version 0.1: empty skeleton.
*/

model assignment3_lion_demography

/* Global section: later holds the parameters (number of lions, number of zebras, ageing speed),
 * age_list, the creation of lions and zebras, the age report in the console,
 * the lion colour from the mean age, and the pause after 500 steps. */
global {

	/* Initialisation: later creates the lions and zebras and fills age_list with the lions' ages. */
	init {
	}
}

/* Lion: later gets an age, walks randomly, gets older, kills zebras within 3 m,
 * is replaced by a baby lion when older than 60, and is drawn as a red circle(3). */
species lion skills: [moving] {
}

/* Zebra: later walks randomly, eats up to 1 kg of grass per step,
 * and is drawn as a grey triangle(2) with a black border. */
species zebra skills: [moving] {
}

/* Grassland: a 50 x 50 grid of grass cells; later gets biomass (0-10 kg at the start,
 * +0.1 kg per step) and a colour from sandy (little grass) to green (much grass). */
grid grassland width: 50 height: 50 {
}

/* GUI experiment: later gets the parameters, the map, the chart of lions and zebras,
 * and the chart of min/mean/max lion age. */
experiment lion_demography_gui type: gui {

	/* Outputs: for now one empty map display. */
	output {
		display map {
		}
	}
}
