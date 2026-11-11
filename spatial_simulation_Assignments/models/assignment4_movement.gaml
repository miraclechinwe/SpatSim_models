/**
* Name: assignment4_movement
* Movement actions and action neighbourhood (see docs/assignment4/Design.md). Version 2.1: world and cows.
*/

model assignment4_movement

/* Global section: will create the cows, sheep and goats in init. */
global {
	/* Shape: the world is a 30 x 30 m field. */
	geometry shape <- square(30);
	/* Init: runs once at the start and creates 5 cows. */
	init {
		create cow number: 5;
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

/* Sheep species: will move towards the south with move. */
species sheep skills: [moving] {
}

/* Goat species: will walk towards the origin with goto. */
species goat skills: [moving] {
}

/* GUI experiment: will show one map display with all agents and their action neighbourhoods. */
experiment main type: gui {
	output {
		/* Map display: light green field, the action areas first, the cows on top. */
		display map background: #lightgreen {
			species cow aspect: area transparency: 0.5;
			species cow aspect: default;
		}
	}
}
