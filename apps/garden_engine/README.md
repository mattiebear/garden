# GardenEngine

## Technical Implementation Brainstorm
- A garden has many plot
- A plot has many soil segments tracked by their coordinates
- A plot can be targeted with an area
- A planting has an area on a plot
- A planting has a plant
- Each soil segment has nutrient values (phosphorus, potassium, nitrogen)
- Each plant has requirements for needs and fixes
- Each plant has time to mature and time to harvest past maturity
- A planting tracks the number of days that have passed since planting
- Any section (area) of the garden can advance in time, which grows the plant and depletes or replenishes nutrients
- Go with standard +y = down for coordination

## Questions to Answer
- How will a plot store information on the coordinates?
- Is the naming convention for plots and coordinates consistent?
