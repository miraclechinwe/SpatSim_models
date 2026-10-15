/**
* Name: NewModel
* Based on the internal skeleton template. 
* Author: owhorji
* Tags: 
*/
model african_savannah

global {
    init {
        create lions number: 20;
        create zebras number: 20;
    }
}

species lions skills: [moving] {

    float speed <- 1.0;

    reflex move_and_kill {
        do wander;

        // Kill any zebra within 2 distance units
        ask zebras at_distance 2 {
            do die;
        }
    }

    aspect default {
        draw circle(3) color: #orange;
    }
}

species zebras skills: [moving] {

    float speed <- 1.0;

    reflex move {
        do wander;
    }

    aspect default {
        draw triangle(2) color: #gray;
    }
}

grid grassland width: 50 height: 50 {

    // Initial grass biomass: between 0 and 10 kg per cell
    // Growth: add 0.1 kg each time step
    float biomass <- rnd(0.0, 10.0)
        update: biomass + 0.1;

    // More biomass produces a brighter green
    rgb color <- rgb(0, int(255 * biomass / (biomass + 10.0)), 0)
        update: rgb(0, int(255 * biomass / (biomass + 10.0)), 0);
}

experiment main_experiment type: gui {

    output {
        display savannah {

            // Draw grass first so the animals appear on top
            grid grassland;

            species zebras aspect: default;
            species lions aspect: default;
        }

        monitor "Lions remaining" value: length(lions);
        monitor "Zebras remaining" value: length(zebras);
    }
}