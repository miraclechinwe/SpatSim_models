# Prompt log – Assignment 3 (Lion demography)

| # | Prompt summary | Change summary | Comment | Model version |
|---|----------------|----------------|---------|---------------|
| 1 | Create DESIGN.md with the model design (purpose, global, lion, zebra, grassland, outputs) and this prompt log. No .gaml file yet. | Created docs/assignment3/DESIGN.md and docs/assignment3/PROMPT_LOG.md. | Design only; Claude showed the plan first and waited for approval. | 0.0 (design only) |
| 2 | Create the model skeleton: empty global with init, species lion and zebra (moving), grid grassland 50 x 50, gui experiment with an empty map display. | Created models/assignment3_lion_demography.gaml. | Skeleton only, no variables, reflexes or agents. | 0.1 (skeleton) |
| 3 | Implement the Savannah base: lions and zebras (parameters nb_lions_init and nb_zebras_init, default 20, sliders 0-100), random walk, lions kill zebras within 3 m, grass grid (0-10 kg, +0.1 kg/step, sandy to green), zebras eat 1 kg/step, map and lion/zebra chart, pause at step 500. | Filled in global, lion, zebra, grassland and experiment in models/assignment3_lion_demography.gaml. | Claude asked about the parameters, the chart display and the grass colour; I chose parameters now, a separate population_chart display and the Assignment 2 grass colour. No age, list or demography yet. | 0.2 (Savannah base) |
