/**
* Name: assignment5_dashboard
* Assignment 5: verification dashboard for the On the move model (copy of Assignment 4 v2.3). Version 1.6: total_distance for every animal, cow_turns, sheep_first_step and cow_first_step in the global, sheep stop in the south, monitors for sheep in the south and goats at the origin, time series of the goats' mean total distance, scatterplot of the first step and histogram of the cow direction changes.
*/

model assignment5_dashboard

/* Global section: will create the cows, sheep and goats in init. */
global {
	/* Shape: the world is a 30 x 30 m field. */
	geometry shape <- square(30);
	/* Cow turns: every direction change of every cow (degrees, -180 to +180), 5 new values each step. */
	list<float> cow_turns <- [];
	/* Sheep first step: mean distance of the sheep in the first time step (m), recorded at cycle 1. */
	float sheep_first_step <- 0.0;
	/* Cow first step: mean distance of the cows in the first time step (m), recorded at cycle 1. */
	float cow_first_step <- 0.0;
	/* Sheep in the south: number of sheep within one step of the bottom edge, updated every step. */
	int sheep_in_south <- 0 update: sheep count (each.location.y >= shape.height - each.speed);
	/* Goats at the origin: number of goats closer than 0.01 m to {0, 0}, updated every step. */
	int goats_at_origin <- 0 update: goat count (each.location distance_to {0, 0} < 0.01);
	/* Init: runs once at the start and creates 5 cows, 3 sheep and 2 goats. */
	init {
		create cow number: 5;
		create sheep number: 3;
		create goat number: 2;
	}
	/* Reflex record_first_step: at cycle 1 every animal has moved once, so its total_distance is its first step. */
	reflex record_first_step when: cycle = 1 {
		sheep_first_step <- mean(sheep collect each.total_distance);
		cow_first_step <- mean(cow collect each.total_distance);
	}
}

/* Cow species: does a correlated random walk with wander and shows its action area. */
species cow skills: [moving] {
	/* Speed: 2 m per step, used by wander and as the radius of the action area. */
	float speed <- 2.0;
	/* Action area: where the cow can be in the next step. */
	geometry action_area;
	/* Total distance: metres travelled since the start, the sum of all step lengths. */
	float total_distance <- 0.0;

	/* Reflex walk: wanders at its speed, turning at most 90 degrees from its heading, then adds the length of this step to total_distance and the turn to cow_turns. */
	reflex walk {
		point old_location <- location;
		float old_heading <- heading;
		do wander amplitude: 90.0 speed: speed;
		total_distance <- total_distance + (old_location distance_to location);
		float turn <- heading - old_heading;
		turn <- turn - 360 * round(turn / 360); // wrap to -180..+180
		add turn to: cow_turns;
	}
	/* Reflex update_area: after walk, the 90 degree slice of circle(speed) around the heading. */
	reflex update_area {
		action_area <- circle(speed) intersection cone(int(heading - 45), int(heading + 45));
	}
	/* Aspect default: the cow as a small brown filled circle. */
	aspect default {
		draw circle(0.5) color: rgb(120, 70, 30);
	}
	/* Aspect area: the action area in goldenrod, only once it exists. */
	aspect area {
		if (action_area != nil) {
			draw action_area color: #goldenrod;
		}
	}
}

/* Sheep species: walks south with move and shows a line one step ahead. */
species sheep skills: [moving] {
	/* Speed: 1 m per step, also the length of the action area line. */
	float speed <- 1.0;
	/* Heading: 90 degrees, which is south (east = 0). */
	float heading <- 90.0;
	/* Action area: where the sheep can be in the next step. */
	geometry action_area;
	/* Total distance: metres travelled since the start, the sum of all step lengths. */
	float total_distance <- 0.0;

	/* Reflex walk: moves one step along its heading at its speed, then adds the length of this step to total_distance. It only walks while there is room for a full step, so it stops in the south instead of bouncing back. */
	reflex walk when: location.y < world.shape.height - speed {
		point old_location <- location;
		do move;
		total_distance <- total_distance + (old_location distance_to location);
	}
	/* Reflex update_area: after walk, the line from the sheep to one step south. */
	reflex update_area {
		action_area <- line([location, location + {0, speed}]);
	}
	/* Aspect default: the sheep as a small black filled circle. */
	aspect default {
		draw circle(0.5) color: #black;
	}
	/* Aspect area: the action area line, thickened by 0.3 m, in goldenrod. */
	aspect area {
		if (action_area != nil) {
			draw action_area + 0.3 color: #goldenrod;
		}
	}
}

/* Goat species: walks slowly to the origin with goto and shows its next step on the way. */
species goat skills: [moving] {
	/* Speed: 0.5 m per step, also the radius that cuts the line to the origin. */
	float speed <- 0.5;
	/* Action area: where the goat can be in the next step. */
	geometry action_area;
	/* Total distance: metres travelled since the start, the sum of all step lengths. */
	float total_distance <- 0.0;

	/* Reflex walk: moves at its speed straight towards the origin {0, 0}, then adds the length of this step to total_distance. */
	reflex walk {
		point old_location <- location;
		do goto target: {0, 0} speed: speed;
		total_distance <- total_distance + (old_location distance_to location);
	}
	/* Reflex update_area: after walk, the part of the line to the origin within one step. */
	reflex update_area {
		action_area <- line([location, {0, 0}]) intersection circle(speed);
	}
	/* Aspect default: the goat as a small yellow filled circle. */
	aspect default {
		draw circle(0.5) color: #yellow;
	}
	/* Aspect area: the action area line, thickened by 0.3 m, in goldenrod. */
	aspect area {
		if (action_area != nil) {
			draw action_area + 0.3 color: #goldenrod;
		}
	}
}

/* GUI experiment: will show one map display with all agents and their action neighbourhoods. */
experiment main type: gui {
	output {
		layout #split;
		/* Map display: light green field, the action areas first, the animals on top. */
		display map background: #lightgreen {
			species cow aspect: area transparency: 0.5;
			species cow aspect: default;
			species sheep aspect: area transparency: 0.5;
			species sheep aspect: default;
			species goat aspect: area transparency: 0.5;
			species goat aspect: default;
		}
		monitor "Sheep in the south (of 3)" value: sheep_in_south;
		monitor "Goats at the origin (of 2)" value: goats_at_origin;
		/* Goat distance display: time series of the mean total distance travelled by the goats. */
		display goat_distance {
			chart "Mean total distance of the goats" type: series x_label: "cycle" y_label: "m" {
				data "goats" value: mean(goat collect each.total_distance) color: #orange;
			}
		}
		display first_step {
			chart "First step: sheep vs cows" type: scatter x_label: "Mean distance of sheep (m)" y_label: "Mean distance of cows (m)" {
				data "first step" value: {sheep_first_step, cow_first_step} color: #black;
			}
		}
		display cow_turn_histogram {
			chart "Cows: direction changes (5 degree bins)" type: histogram x_label: "Direction change (degrees)" y_label: "Count" {
				datalist (distribution_of(cow_turns, 72, -180, 180) at "legend")
					value: (distribution_of(cow_turns, 72, -180, 180) at "values");
			}
		}
	}
}
