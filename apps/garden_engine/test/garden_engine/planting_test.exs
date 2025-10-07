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

  describe "age_in_days/2" do
    test "returns the age of the planting", %{plant: plant, area: area} do
      current_date = ~D[2025-10-05]
      planting = Planting.new(plant, area, planted_on: current_date)
      assert Planting.age_in_days(planting, current_date) == 0
      assert Planting.age_in_days(planting, ~D[2025-10-06]) == 1
      assert Planting.age_in_days(planting, ~D[2025-12-05]) == 61
    end
  end

  describe "current_stage/2" do
    test "returns growing if the planting is not mature", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      assert Planting.current_stage(planting, Date.utc_today()) == :growing
    end

    test "returns producing if the planting is mature", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      date = Date.utc_today() |> Date.add(plant.days_to_maturity)

      assert Planting.current_stage(planting, date) == :producing
    end

    test "returns finished if the planting is finished", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      date = Date.utc_today() |> Date.add(plant.days_to_maturity + plant.days_productive)

      assert Planting.current_stage(planting, date) == :finished
    end
  end

  describe "nutrient_adjustment_required?/2" do
    test "returns true if the planting is not growing and nutrients have not been applied", %{
      plant: plant,
      area: area
    } do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      date = Date.utc_today() |> Date.add(plant.days_to_maturity)

      assert Planting.nutrient_adjustment_required?(planting, date)
    end

    test "returns false if the planting is growing", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      date = Date.utc_today()

      refute Planting.nutrient_adjustment_required?(planting, date)
    end

    test "returns false if nutrients have been applied", %{plant: plant, area: area} do
      planting = Planting.new(plant, area, planted_on: Date.utc_today())
      date = Date.utc_today() |> Date.add(plant.days_to_maturity)

      planting = %{planting | nutrients_adjusted?: true}

      refute Planting.nutrient_adjustment_required?(planting, date)
    end
  end

  def plant_and_area(context) do
    plant = Plant.new("tomato", days_to_maturity: 60, days_productive: 30)
    area = Area.new(3, 3)

    Map.merge(context, %{plant: plant, area: area})
  end
end
