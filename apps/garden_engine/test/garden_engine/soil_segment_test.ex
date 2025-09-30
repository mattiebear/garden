defmodule SoilSegmentTest do
  use ExUnit.Case, async: true
  doctest GardenEngine.SoilSegment

  alias GardenEngine.SoilSegment

  describe "new/0" do
    test "creates a soil segment with default values" do
      assert %SoilSegment{n_level: 50, p_level: 50, k_level: 50} = SoilSegment.new()
    end
  end

  describe "new/3" do
    test "creates a soil segment with the provided nutrient values" do
      assert %SoilSegment{n_level: 25, p_level: 50, k_level: 75} = SoilSegment.new(25, 50, 75)
    end

    test "clamps the nutrient values to the valid range" do
      assert %SoilSegment{n_level: 100, p_level: 100, k_level: 100} =
               SoilSegment.new(150, 150, 150)
    end
  end

  describe "adjust_nitrogen/2" do
    setup :default_segment

    test "adjusts the nitrogen up by the given delta", %{segment: segment} do
      assert %SoilSegment{n_level: 75} = SoilSegment.adjust_nitrogen(segment, 25)
    end

    test "adjusts the nitrogen down by the given delta", %{segment: segment} do
      assert %SoilSegment{n_level: 25} = SoilSegment.adjust_nitrogen(segment, -25)
    end

    test "clamps the nitrogen value to the valid range", %{segment: segment} do
      assert %SoilSegment{n_level: 100} = SoilSegment.adjust_nitrogen(segment, 100)
    end
  end

  describe "adjust_phosphorus/2" do
    setup :default_segment

    test "adjusts the phosphorus up by the given delta", %{segment: segment} do
      assert %SoilSegment{p_level: 75} = SoilSegment.adjust_phosphorus(segment, 25)
    end

    test "adjusts the phosphorus down by the given delta", %{segment: segment} do
      assert %SoilSegment{p_level: 25} = SoilSegment.adjust_phosphorus(segment, -25)
    end

    test "clamps the phosphorus value to the valid range", %{segment: segment} do
      assert %SoilSegment{p_level: 100} = SoilSegment.adjust_phosphorus(segment, 100)
    end
  end

  describe "adjust_potassium/2" do
    setup :default_segment

    test "adjusts the potassium up by the given delta", %{segment: segment} do
      assert %SoilSegment{k_level: 75} = SoilSegment.adjust_potassium(segment, 25)
    end

    test "adjusts the potassium down by the given delta", %{segment: segment} do
      assert %SoilSegment{k_level: 25} = SoilSegment.adjust_potassium(segment, -25)
    end

    test "clamps the potassium value to the valid range", %{segment: segment} do
      assert %SoilSegment{k_level: 100} = SoilSegment.adjust_potassium(segment, 100)
    end
  end

  def default_segment(context) do
    Map.put(context, :segment, SoilSegment.new(50, 50, 50))
  end
end
