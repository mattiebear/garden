# GardenEngine

A soil nutrient management and crop rotation planning system for home gardeners. GardenEngine simulates garden plots as grids of soil segments, tracking nutrient levels and plant growth over time to help plan sustainable crop rotations.

## Overview

GardenEngine helps home gardeners understand how different crops affect soil health and plan effective crop rotations. Rather than complex daily nutrient tracking, the system focuses on seasonal impacts - how plants affect soil when they complete their growing cycle.

### Key Concepts

- **Plots**: Garden beds represented as grids of 6"×6" soil segments
- **Soil Segments**: Individual squares tracking nitrogen (N), phosphorus (P), and potassium (K) levels (0-10 scale)
- **Plants**: Crop definitions with nutrient impacts and growth characteristics
- **Plantings**: Specific plants growing in specific areas of a plot
- **Time Advancement**: Track plant growth daily, apply soil changes when crops complete their cycle

## Core Modules

### `GardenEngine.Plot`
Represents a garden plot as a grid of soil segments. Manages plantings and handles time advancement.

**Key Functions:**
- `new/2` - Create a plot with specified dimensions
- `add_planting/4` - Add a named plant to a specific area
- `advance_time/2` - Move time forward and update plant growth
- `get_planting/2` - Retrieve a specific planting by ID

### `GardenEngine.SoilSegment`
Individual 6"×6" soil squares with nutrient levels on a 0-10 scale.

**Key Functions:**
- `new/3` - Create segment with specified N/P/K levels (defaults to 5/5/5)
- `apply_plant_impact/2` - Apply a plant's nutrient changes to the segment

### `GardenEngine.Area` 
Geometric rectangle representing space in the garden with intersection capabilities.

**Key Functions:**
- `new/4` - Create area with width, depth, and coordinates
- `intersection/2` - Find overlapping area between two areas
- `coordinates/1` - Get list of {x,y} coordinate tuples
- `overlaps?/2` - Check if two areas intersect

### `GardenEngine.EmptyArea`
Null object representing no area - result of non-intersecting areas. Implements same interface as Area but returns empty results.

### `GardenEngine.Plant`
Taxonomical plant data with growth characteristics and soil impacts.

**Structure:**
- `name` - Plant variety name
- `n_impact, p_impact, k_impact` - Nutrient changes when growing cycle completes
- `maturity_days` - Days from planting to harvest
- `growth_curve` - How nutrient consumption changes over time

### `GardenEngine.PlantLibrary`
Predefined plant database with common garden crops.

**Key Functions:**
- `get/1` - Retrieve plant by name (returns {:ok, plant} | {:error, :not_found})
- `get!/1` - Retrieve plant by name (raises if not found)
- `available_plants/0` - List all plant names

### `GardenEngine.Planting`
Represents a specific plant growing in a specific area, tracking age and growth stage.

**Key Functions:**
- `new/3` - Create planting with plant, area, and options
- `age/2` - Calculate current age in days
- `current_stage/2` - Determine growth stage (:seedling, :vegetative, :flowering, etc.)

## Usage Example

```elixir
# Create a 4×4 plot
plot = Plot.new(4, 4)

# Get plants from library
{:ok, tomato} = PlantLibrary.get("tomato")
{:ok, beans} = PlantLibrary.get("beans")

# Add plantings with meaningful names
{:ok, plot} = Plot.add_planting(plot, "main_tomatoes", tomato, Area.new(2, 2, 0, 0))
{:ok, plot} = Plot.add_planting(plot, "companion_beans", beans, Area.new(1, 2, 2, 0))

# Advance time - plants grow daily, soil changes when they complete cycles
plot = Plot.advance_time(plot, 30)  # 30 days later

# Check plant status
{:ok, tomato_planting} = Plot.get_planting(plot, "main_tomatoes")
stage = Planting.current_stage(tomato_planting, plot.current_day)
# => :vegetative

# When plants complete their cycle, soil nutrients change automatically
plot = Plot.advance_time(plot, 45)  # Beans complete cycle, fix nitrogen in soil
```

## Design Philosophy

- **Simplicity over precision**: Focus on practical crop rotation planning rather than scientific simulation
- **Seasonal thinking**: Soil changes happen when crops complete their cycle, not daily
- **Meaningful scales**: 0-10 nutrient levels are intuitive and actionable
- **Home gardener focused**: Terminology and concepts match how gardeners actually think about soil management

## Coordinate System

The system uses standard screen coordinates:
- Origin (0,0) at top-left
- X-axis increases rightward  
- Y-axis increases downward
- Each coordinate represents a 6"×6" soil segment