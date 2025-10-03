defmodule GardenEngine.PlantingTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, Plant, Planting}

  setup :plant_and_area

  describe "new/2" do
    test "creates a new planting", %{plant: plant, area: area} do
      planting = Planting.new(plant, area)
      assert planting.plant == plant
      assert planting.area == area
      assert planting.age == 0
    end
  end

  describe "new/3" do
    test "creates a new planting with the provided options", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, age: 10)
      assert planting.plant == plant
      assert planting.area == area
      assert planting.age == 10
    end
  end

  def plant_and_area(context) do
    plant = Plant.new("tomato")
    area = Area.new(3, 3)

    Map.merge(context, %{plant: plant, area: area})
  end
end
