/**
* Name: savanna
* Based on the internal empty template. 
* Author: owhor
* Tags: 
*/

model savanna

global {
	init {
		create zebra number: 20; // make 20 zebras at the start
		create lion number: 20; // make 20 lions at the start
	}
	reflex stop_at_500 when: cycle = 500 { // when we reach cycle 500...
		do pause; // ...pause the simulation automatically
	}
}

// lion
species lion skills: [moving] { // lion can move
	reflex walk {
		do wander; // lion walks randomly every step
	}
	reflex hunt {
		ask zebra at_distance 3 { // look for zebras touching the lion
			do die; // zebra is killed and removed
		}
	}
	aspect default {
		draw circle(3) color: #orange border: #black; // lion is an orange circle, size 3
	}
}

// zebra
species zebra skills: [moving] { // zebra can move
	reflex walk {
		do wander; // zebra walks randomly every step
	}
	aspect default {
		draw triangle(2) color: #grey border: #black; // zebra is a grey triangle, size 2
	}
}

// grass
grid grassland width: 50 height: 50 { // field cut into 50 x 50 tiles
	float biomass <- rnd(10.0); // each tile gets random grass, 0 to 10 kg
	rgb color <- rgb(int(220 - 6.5 * biomass), int(200 - 3 * biomass), int(120 - 4 * biomass)); // sandy = little grass, green = much grass

	reflex grow {
		biomass <- biomass + 0.1; // grass grows 0.1 kg every step
		float g <- min([biomass, 20.0]); // colour stops changing at 20 kg
		color <- rgb(int(220 - 6.5 * g), int(200 - 3 * g), int(120 - 4 * g)); // repaint the tile
	}
}

experiment play type: gui {
	output {
		display field { // window that shows the savannah
			grid grassland; // show the grass first (at the bottom)
			species zebra aspect: default; // show the zebras
			species lion aspect: default; // show the lions
		}
		display zebra_chart type: 2d background: #white { // second window: the chart (2d)
			chart "Number of zebras over time" type: series // a line chart over time
				background: #white // white background
				color: rgb(60, 60, 60) // dark grey text
				axes: rgb(200, 200, 200) // light grey axes and grid lines
				x_label: "Time (cycles)" // name of the bottom axis
				y_label: "Zebras alive" // name of the side axis
				y_range: {0, 21} // side axis goes from 0 to 21
				series_label_position: none // hide the legend box
				title_font: font("Arial", 16, #bold) // big bold title
				label_font: font("Arial", 12, #plain) // axis names
				tick_font: font("Arial", 11, #plain) { // axis numbers
				data "zebras" value: length(zebra) color: rgb(33, 113, 181) marker: false thickness: 3.0; // blue smooth line, no dots
			}
		}
	}
}