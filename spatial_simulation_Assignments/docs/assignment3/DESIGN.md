# Assignment 3 – Lion demography in the Savannah (model design)

## Purpose
How does the age of a lion population change over time when old lions die and are replaced by babies?

## Parts of the model
- global (the world), species lion, species zebra, grid grassland (grass)

## Global
- Parameters: number of lions (20), number of zebras (20), ageing speed in years per step (1.0)
- age_list: a list with the current age of every lion
- At the start: create lions and zebras, then add every lion's age to age_list
- Every step: remove the old values from age_list and add the current ages
- Every step: write the number of values, minimum, mean and maximum age in the console
- Every step: set the lion colour from the mean age (light red = young, dark red = old)
- Pause after 500 steps

## Lion
- age in years, random start between 0 and 60
- every step: walks randomly, gets older by the ageing speed, kills zebras within 3 m
- if age > 60: first a baby lion (age 0) is born at the same place, then the old lion dies
- drawn as circle(3) with black border in the red shade

## Zebra
- walks randomly, eats up to 1 kg grass per step; grey triangle(2) with black border

## Grassland
- 50 x 50 cells, biomass 0-10 kg at the start, grows 0.1 kg per step; sandy = little grass, green = much grass

## Outputs
- map, chart of lions and zebras over time, chart of min/mean/max lion age, console report
