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
    setup [:plant, :plot_with_planting]

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

  describe "advance/2" do
    setup [:plant]

    test "updates nutrient adjustment status on plantings that have matured", %{plant: plant} do
      plot = Plot.new(2, 2)
      area = Area.new(1, 1, 0, 0)
      {:ok, plot} = Plot.add_planting(plot, "plant1", plant, area)

      assert {:ok, plot} = Plot.advance(plot, Date.add(Date.utc_today(), 15))
      assert Map.get(plot.plantings, "plant1").nutrients_adjusted?
    end

    test "applies nutrient adjustments to soil segments for matured plantings", %{plant: plant} do
      plot = Plot.new(2, 2)
      area = Area.new(1, 1, 0, 0)
      {:ok, plot} = Plot.add_planting(plot, "plant1", plant, area)

      assert Map.get(plot.segments, {0, 0}) == %SoilSegment{
               n_level: 50,
               p_level: 50,
               k_level: 50
             }

      assert {:ok, plot} = Plot.advance(plot, Date.add(Date.utc_today(), 15))

      assert Map.get(plot.segments, {0, 0}) == %SoilSegment{
               n_level: 48,
               p_level: 49,
               k_level: 49
             }

      assert Map.get(plot.segments, {0, 1}) == %SoilSegment{
               n_level: 50,
               p_level: 50,
               k_level: 50
             }

      assert Map.get(plot.segments, {1, 0}) == %SoilSegment{
               n_level: 50,
               p_level: 50,
               k_level: 50
             }

      assert Map.get(plot.segments, {1, 1}) == %SoilSegment{
               n_level: 50,
               p_level: 50,
               k_level: 50
             }
    end

    test "does not re-apply nutrient adjustments to soil segments for matured plantings", %{
      plant: plant
    } do
      plot = Plot.new(2, 2)
      area = Area.new(1, 1, 0, 0)
      {:ok, plot} = Plot.add_planting(plot, "plant1", plant, area)

      assert {:ok, plot} = Plot.advance(plot, Date.add(Date.utc_today(), 15))
      assert {:ok, plot} = Plot.advance(plot, Date.add(Date.utc_today(), 15))

      assert Map.get(plot.segments, {0, 0}) == %SoilSegment{
               n_level: 48,
               p_level: 49,
               k_level: 49
             }

      assert {:ok, plot} = Plot.advance(plot, Date.add(Date.utc_today(), 30))

      assert Map.get(plot.segments, {0, 0}) == %SoilSegment{
               n_level: 48,
               p_level: 49,
               k_level: 49
             }
    end
  end

  defp plant(context) do
    Map.put(context, :plant, Plant.new("tomato", n_impact: -2, p_impact: -1, k_impact: -1))
  end

  defp plot_with_planting(context) do
    plot = Plot.new(2, 2)
    area = Area.new(1, 1)

    plant =
      Plant.new("tomato",
        days_to_maturity: 10,
        productive_days: 10,
        n_impact: 2,
        p_impact: 1,
        k_impact: 1
      )

    {:ok, plot} = Plot.add_planting(plot, "tomato", plant, area)

    Map.put(context, :plot, plot)
  end
end
