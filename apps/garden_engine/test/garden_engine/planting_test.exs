defmodule GardenEngine.PlantingTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, Plant, Planting}

  setup :plant_and_area

  describe "new/2" do
    test "creates a new planting", %{plant: plant, area: area} do
      planting = Planting.new(plant, area)
      assert planting.plant == plant
      assert planting.area == area
      assert planting.planted_on == Date.utc_today()
    end
  end

  describe "new/3" do
    test "creates a new planting with the provided options", %{plant: plant, area: area} do
      date = ~D[2025-10-05]
      planting = Planting.new(plant, area, planted_on: date)
      assert planting.plant == plant
      assert planting.area == area
      assert planting.planted_on == date
    end
  end

  describe "age/2" do
    test "returns the age of the planting", %{plant: plant, area: area} do
      current_date = ~D[2025-10-05]
      planting = Planting.new(plant, area, planted_on: current_date)
      assert Planting.age(planting, current_date) == 0
      assert Planting.age(planting, ~D[2025-10-06]) == 1
      assert Planting.age(planting, ~D[2025-12-05]) == 61
    end
  end

  def plant_and_area(context) do
    plant = Plant.new("tomato")
    area = Area.new(3, 3)

    Map.merge(context, %{plant: plant, area: area})
  end
end
