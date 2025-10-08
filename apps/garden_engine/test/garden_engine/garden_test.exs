defmodule GardenEngine.GardenTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, Garden, Plant, Plot, SoilSegment}

  describe "new/1" do
    test "creates a new garden" do
      assert %Garden{} = Garden.new()
    end

    test "creates a new garden with current date" do
      current_date = ~D[2025-06-07]
      assert %Garden{current_date: date} = Garden.new(current_date: current_date)
      assert date == current_date
    end
  end

  describe "add_plot/3" do
    setup [:garden]

    test "adds a new plot", %{garden: garden} do
      assert {:ok, garden} = Garden.add_plot(garden, "new plot", Plot.new(8, 4))
      assert %Plot{} = garden.plots["new plot"]
    end

    test "returns an error when plot already exists", %{garden: garden} do
      assert {:ok, garden} = Garden.add_plot(garden, "new plot", Plot.new(8, 4))

      assert {:error, "Plot with ID already exists"} =
               Garden.add_plot(garden, "new plot", Plot.new(8, 4))
    end
  end

  describe "get_plot/2" do
    setup [:garden]

    test "gets a plot by ID", %{garden: garden} do
      plot = Plot.new(8, 4)
      assert {:ok, garden} = Garden.add_plot(garden, "new plot", plot)
      assert {:ok, garden_plot} = Garden.get_plot(garden, "new plot")
      assert garden_plot == plot
    end

    test "returns an error when plot does not exist", %{garden: garden} do
      assert {:error, "Plot with ID not found"} = Garden.get_plot(garden, "nonexistent plot")
    end
  end

  describe "add_planting/5" do
    setup [:garden_with_plot, :plant]

    test "adds a new planting", %{garden: garden, plant: plant} do
      area = Area.new(1, 1, 0, 0)

      assert {:ok, garden} =
               Garden.add_planting(garden, "plot", "plant", plant, area)

      assert garden.plots["plot"].plantings["plant"].plant == plant
    end
  end

  describe "advance/2" do
    setup [:garden_with_plot, :plant]

    test "does not advance to a date in the past", %{garden: garden} do
      assert {:error, "Can't advance to a date in the past"} =
               Garden.advance(garden, Date.add(Date.utc_today(), -3))
    end

    test "advances the date on all plots", %{garden: garden, plant: plant} do
      area = Area.new(1, 1, 0, 0)
      {:ok, garden} = Garden.add_planting(garden, "plot", "plant1", plant, area)

      assert {:ok, garden} = Garden.advance(garden, Date.add(Date.utc_today(), 3))

      {:ok, plot} = Garden.get_plot(garden, "plot")
      segment = Map.get(plot.segments, {0, 0})

      assert segment == %SoilSegment{n_level: 45, p_level: 50, k_level: 50}
    end
  end

  defp garden(context) do
    Map.put(context, :garden, Garden.new())
  end

  defp garden_with_plot(context) do
    plot = Plot.new(4, 4)
    garden = %Garden{plots: %{"plot" => plot}, current_date: Date.utc_today()}

    Map.put(context, :garden, garden)
  end

  defp plant(context) do
    Map.put(context, :plant, Plant.new("Beans", days_to_maturity: 3, n_impact: -5))
  end
end
