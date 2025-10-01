defmodule GardenEngine.PlotTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, Plot, SoilSegment}

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
end
