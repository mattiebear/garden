defmodule GardenEngine.PlotTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, Plant, Plot, SoilSegment}

  describe "new/2" do
    test "creates an plot with an area of the given dimensions" do
      assert %Plot{area: area} = Plot.new(2, 2)
      assert area == Area.new(2, 2)
    end

    test "initializes soil segments for each coordinate" do
      plot = Plot.new(2, 2)

      assert map_size(plot.segments) == 4

      expected_coordinates = [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

      Enum.each(expected_coordinates, fn coord ->
        assert Map.has_key?(plot.segments, coord)
        assert %SoilSegment{} = plot.segments[coord]
      end)
    end
  end

  describe "add_planting/4" do
    setup [:with_plant, :plot_with_planting]

    test "adds a new planting to the plot", %{plant: plant} do
      plot = Plot.new(2, 2)
      area = Area.new(2, 2)

      assert {:ok, plot} = Plot.add_planting(plot, "tomato", plant, area)
      assert Map.has_key?(plot.plantings, "tomato")
      assert Map.get(plot.plantings, "tomato").area == area
    end

    test "does not add a planting if the id is already used", %{plant: plant, plot: plot} do
      area = Area.new(2, 2)

      assert {:error, "Planting already exists with provided ID"} =
               Plot.add_planting(plot, "tomato", plant, area)
    end

    test "does not add a planting if the space is already occupied", %{plant: plant, plot: plot} do
      area = Area.new(1, 1)

      assert {:error, "Area already occupied"} =
               Plot.add_planting(plot, "other_tomato", plant, area)
    end
  end

  defp with_plant(context) do
    Map.put(context, :plant, Plant.new("tomato"))
  end

  defp plot_with_planting(context) do
    plot = Plot.new(2, 2)
    area = Area.new(1, 1)
    plant = Plant.new("tomato")

    {:ok, plot} = Plot.add_planting(plot, "tomato", plant, area)

    Map.put(context, :plot, plot)
  end
end
