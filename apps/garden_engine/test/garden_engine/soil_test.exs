defmodule GardenEngine.SoilTest do
  use ExUnit.Case

  alias GardenEngine.Soil

  doctest GardenEngine.Soil

  describe "feeding (using) nutrients" do
    setup :default_soil

    test "feeds high nitrogen use", %{soil: soil} do
      assert Soil.feed_nitrogen(soil, :high).nitrogen_level == -3
    end

    test "feeds medium nitrogen use", %{soil: soil} do
      assert Soil.feed_nitrogen(soil, :medium).nitrogen_level == -2
    end

    test "feeds low nitrogen use", %{soil: soil} do
      assert Soil.feed_nitrogen(soil, :low).nitrogen_level == -1
    end

    test "feeds high phosphorus use", %{soil: soil} do
      assert Soil.feed_phosphorus(soil, :high).phosphorus_level == -3
    end

    test "feeds medium phosphorus use", %{soil: soil} do
      assert Soil.feed_phosphorus(soil, :medium).phosphorus_level == -2
    end

    test "feeds low phosphorus use", %{soil: soil} do
      assert Soil.feed_phosphorus(soil, :low).phosphorus_level == -1
    end

    test "feeds high potassium use", %{soil: soil} do
      assert Soil.feed_potassium(soil, :high).potassium_level == -3
    end

    test "feeds medium potassium use", %{soil: soil} do
      assert Soil.feed_potassium(soil, :medium).potassium_level == -2
    end

    test "feeds low potassium use", %{soil: soil} do
      assert Soil.feed_potassium(soil, :low).potassium_level == -1
    end
  end

  describe "fixing nutrients" do
    setup :default_soil

    test "fixes nitrogen", %{soil: soil} do
      assert Soil.fix_nitrogen(soil).nitrogen_level == 2
    end

    test "fixes phosphorus", %{soil: soil} do
      assert Soil.fix_phosphorus(soil).phosphorus_level == 2
    end

    test "fixes potassium", %{soil: soil} do
      assert Soil.fix_potassium(soil).potassium_level == 2
    end
  end

  describe "nutrient ranges" do
    test "clamps maximum value" do
      soil = Soil.new() |> Map.put(:nitrogen_level, 6)
      assert Soil.fix_nitrogen(soil).nitrogen_level == 7
    end

    test "clamps minimum value" do
      soil = Soil.new() |> Map.put(:nitrogen_level, -6)
      assert Soil.feed_nitrogen(soil, :high).nitrogen_level == -7
    end
  end

  defp default_soil(context) do
    {:ok, Map.put(context, :soil, Soil.new())}
  end
end
