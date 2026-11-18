/**
* Name: assignment5_dashboard
* Assignment 5 - Verification dashboard for the "On the move" model (based on Assignment 4, v2.3)
* Version 1.8
*
* Animals:   5 cows (correlated random walk), 3 sheep (walk south), 2 goats (go to the origin)
* Dashboard: 2 monitors, goat distance chart, first-step scatterplot, cow turn histogram
* End:       when all sheep are in the south and all goats at the origin -> save data, pause
*/

model assignment5_dashboard

global {
	// ================= WORLD =================
	geometry shape <- square(30);                         // 30 x 30 m field

	// ================= DATA FOR THE CHARTS =================
	list<float> cow_turns <- [];                          // every cow direction change (degrees), grows every step
	float sheep_first_step <- 0.0;                        // mean sheep distance in step 1 (scatterplot x)
	float cow_first_step <- 0.0;                          // mean cow distance in step 1 (scatterplot y)
	list<string> bin_labels <- range(0, 71) collect string(-180 + 5 * each);   // histogram labels: -180, -175 ... 175

	// ================= MONITORS (recalculated every step) =================
	int sheep_in_south <- 0 update: sheep count (each.location.y >= shape.height - each.speed);
	int goats_at_origin <- 0 update: goat count (each.location distance_to {0, 0} < 0.01);

	// ================= START =================
	init {
		create cow number: 5;
		create sheep number: 3;
		create goat number: 2;
	}

	// ================= EVERY STEP =================
	// After the first step (cycle 1) each animal's total_distance = its first-step distance.
	reflex record_first_step when: cycle = 1 {
		sheep_first_step <- mean(sheep collect each.total_distance);
		cow_first_step <- mean(cow collect each.total_distance);
	}

	// End: all sheep in the south and all goats at the origin -> save the data and pause.
	reflex save_and_stop when: sheep_in_south = length(sheep) and goats_at_origin = length(goat) {
		save [cycle, mean(goat collect each.total_distance), sheep_first_step, cow_first_step,
			length(cow_turns), min(cow_turns), max(cow_turns)]
			to: "../docs/assignment5/summary.csv" format: "csv" rewrite: true;
		save cow_turns to: "../docs/assignment5/cow_turns.csv" format: "csv" rewrite: true;
		do pause;
	}
}

// ================= COWS: correlated random walk (wander) =================
species cow skills: [moving] {
	float speed <- 2.0;                 // 2 m per step
	float total_distance <- 0.0;        // pedometer: metres walked since the start
	geometry action_area;               // where the cow can be in the next step

	reflex walk {
		point old_location <- location;
		float old_heading <- heading;
		do wander amplitude: 90.0 speed: speed;                          // turn at most 45 deg left or right
		total_distance <- total_distance + (old_location distance_to location);
		float turn <- heading - old_heading;
		add turn - 360 * round(turn / 360) to: cow_turns;                // wrap to -180..+180 (e.g. -340 -> +20)
	}

	reflex update_area {               // slice of a circle: radius = speed, +-45 deg around the heading
		action_area <- circle(speed) intersection cone(int(heading - 45), int(heading + 45));
	}

	aspect default { draw circle(0.5) color: rgb(120, 70, 30); }
	aspect area { if (action_area != nil) { draw action_area color: #goldenrod; } }
}

// ================= SHEEP: walk south (move) =================
species sheep skills: [moving] {
	float speed <- 1.0;                 // 1 m per step
	float heading <- 90.0;              // south (east = 0, clockwise)
	float total_distance <- 0.0;
	geometry action_area;

	// Walk only while there is room for a full step -> stops in the south (fix: before, sheep bounced back).
	reflex walk when: location.y < world.shape.height - speed {
		point old_location <- location;
		do move;
		total_distance <- total_distance + (old_location distance_to location);
	}

	reflex update_area {               // line one step to the south
		action_area <- line([location, location + {0, speed}]);
	}

	aspect default { draw circle(0.5) color: #black; }
	aspect area { if (action_area != nil) { draw action_area + 0.3 color: #goldenrod; } }   // + 0.3 = thicker line
}

// ================= GOATS: go to the origin (goto) =================
species goat skills: [moving] {
	float speed <- 0.5;                 // 0.5 m per step
	float total_distance <- 0.0;
	geometry action_area;

	reflex walk {
		point old_location <- location;
		do goto target: {0, 0} speed: speed;
		total_distance <- total_distance + (old_location distance_to location);
	}

	reflex update_area {               // line to the origin, cut to one step by a circle of the speed
		action_area <- line([location, {0, 0}]) intersection circle(speed);
	}

	aspect default { draw circle(0.5) color: #yellow; }
	aspect area { if (action_area != nil) { draw action_area + 0.3 color: #goldenrod; } }
}

// ================= DASHBOARD =================
experiment main type: gui {
	output {
		layout #split;                                            // all windows side by side

		// Map: action areas first (half transparent), animals on top
		display map background: #lightgreen {
			species cow aspect: area transparency: 0.5;
			species cow aspect: default;
			species sheep aspect: area transparency: 0.5;
			species sheep aspect: default;
			species goat aspect: area transparency: 0.5;
			species goat aspect: default;
		}

		// Monitors: live checks of the end condition
		monitor "Sheep in the south (of 3)" value: sheep_in_south;
		monitor "Goats at the origin (of 2)" value: goats_at_origin;

		// Time series: mean total distance of the goats
		display goat_distance background: #white {
			chart "Goats: mean total distance travelled" type: series
				x_label: "Time (steps)" y_label: "Distance (m)" y_range: {0, 40} series_label_position: none {
				data "goats" value: mean(goat collect each.total_distance) color: #orange marker: false;
			}
		}

		// Scatterplot: first step, sheep (x) vs cows (y) - one point only
		display first_step background: #white {
			chart "First step: sheep vs cows" type: scatter
				x_label: "Mean distance of sheep (m)" y_label: "Mean distance of cows (m)"
				x_range: {0, 2.5} y_range: {0, 2.5} x_tick_unit: 0.5 y_tick_unit: 0.5 series_label_position: none {
				data "first step" value: {sheep_first_step, cow_first_step} color: #black
					accumulate_values: false line_visible: false;
			}
		}

		// Histogram: all cow direction changes, 72 bins of 5 degrees from -180 to +180
		display cow_turn_histogram background: #white {
			chart "Cows: direction changes (5 degree bins)" type: histogram
				x_label: "Direction change (degrees)" y_label: "Count"
				series_label_position: none tick_font: font("Arial", 7, #plain) {
				datalist bin_labels value: (distribution_of(cow_turns, 72, -180, 180) at "values")
					color: list_with(72, #sienna);
			}
		}
	}
}
