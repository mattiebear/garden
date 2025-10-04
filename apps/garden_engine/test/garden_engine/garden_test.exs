defmodule GardenEngine.GardenTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Garden, Plot}

  describe "new/0" do
    test "creates a new garden" do
      assert %Garden{} = Garden.new()
    end
  end

  describe "add_plot/3" do
    setup [:garden, :plot]

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

  defp garden(context) do
    Map.put(context, :garden, Garden.new())
  end

  defp plot(context) do
    Map.put(context, :plot, Plot.new(8, 4))
  end
end
