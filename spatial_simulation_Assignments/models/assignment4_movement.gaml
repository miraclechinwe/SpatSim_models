/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 2.3: world, cows, sheep and goats.
*/

model assignment4_movement

/* Global section: will create the cows, sheep and goats in init. */
global {
	/* Shape: the world is a 30 x 30 m field. */
	geometry shape <- square(30);
	/* Init: runs once at the start and creates 5 cows, 3 sheep and 2 goats. */
	init {
		create cow number: 5;
		create sheep number: 3;
		create goat number: 2;
	}
}

/* Cow species: does a correlated random walk with wander and shows its action area. */
species cow skills: [moving] {
	/* Speed: 2 m per step, used by wander and as the radius of the action area. */
	float speed <- 2.0;
	/* Action area: where the cow can be in the next step. */
	geometry action_area;

	/* Reflex walk: wanders at its speed, turning at most 90 degrees from its heading. */
	reflex walk {
		do wander amplitude: 90.0 speed: speed;
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

	/* Reflex walk: moves one step along its heading at its speed. */
	reflex walk {
		do move;
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

	/* Reflex walk: moves at its speed straight towards the origin {0, 0}. */
	reflex walk {
		do goto target: {0, 0} speed: speed;
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
		/* Map display: light green field, the action areas first, the cows on top. */
		display map background: #lightgreen {
			species cow aspect: area transparency: 0.5;
			species cow aspect: default;
			species sheep aspect: area transparency: 0.5;
			species sheep aspect: default;
			species goat aspect: area transparency: 0.5;
			species goat aspect: default;
		}
	}
}
