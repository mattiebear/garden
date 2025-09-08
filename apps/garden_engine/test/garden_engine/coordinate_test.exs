defmodule GardenEngine.CoordinateTest do
  use ExUnit.Case
  doctest GardenEngine.Coordinate

  describe "new/2" do
    test "creates a new coordinate" do
      assert {:ok, %GardenEngine.Coordinate{x: 5, y: 3}} == GardenEngine.Coordinate.new(5, 3)
    end

    test "returns an error when x is not an integer" do
      assert {:error, "x must be an integer"} == GardenEngine.Coordinate.new("5", 3)
    end

    test "returns an error when y is not an integer" do
      assert {:error, "y must be an integer"} == GardenEngine.Coordinate.new(5, "3")
    end

    test "returns an error when x is negative" do
      assert {:error, "x must be non-negative"} == GardenEngine.Coordinate.new(-5, 3)
    end

    test "returns an error when y is negative" do
      assert {:error, "y must be non-negative"} == GardenEngine.Coordinate.new(5, -3)
    end
  end
end
