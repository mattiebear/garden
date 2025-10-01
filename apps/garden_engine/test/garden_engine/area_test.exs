defmodule GardenEngine.AreaTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Area, EmptyArea}

  describe "new/2" do
    test "creates a new area with the provided dimensions" do
      assert %Area{width: 10, depth: 20, x: 0, y: 0} == Area.new(10, 20)
    end
  end

  describe "new/4" do
    test "creates an area with the provided dimensions and position" do
      assert %Area{width: 10, depth: 20, x: 15, y: 25} == Area.new(10, 20, 15, 25)
    end
  end

  describe "intersect/1" do
    test "returns a matching area when the two areas are equal" do
      area1 = Area.new(5, 6, 3, 3)
      area2 = Area.new(5, 6, 3, 3)

      assert %Area{width: 5, depth: 6, x: 3, y: 3} == Area.intersect(area1, area2)
    end

    test "returns the smaller area when one encloses another" do
      area1 = Area.new(6, 6, 0, 0)
      area2 = Area.new(3, 3, 2, 2)

      assert %Area{width: 3, depth: 3, x: 2, y: 2} == Area.intersect(area1, area2)
    end

    test "returns the shared coordinate space when two areas overlap" do
      area1 = Area.new(4, 4, 0, 0)
      area2 = Area.new(4, 4, 2, 2)

      assert %Area{width: 2, depth: 2, x: 2, y: 2} == Area.intersect(area1, area2)
    end

    test "returns an EmptyArea if there is no overlap" do
      area1 = Area.new(4, 4, 0, 0)
      area2 = Area.new(4, 4, 6, 6)

      assert %EmptyArea{} == Area.intersect(area1, area2)
    end
  end

  describe "coordinates/1" do
    test "returns a list of coordinates in form {x, y} tuples" do
      area = Area.new(3, 3, 1, 1)

      assert [{1, 1}, {1, 2}, {1, 3}, {2, 1}, {2, 2}, {2, 3}, {3, 1}, {3, 2}, {3, 3}] ==
               Area.coordinates(area)
    end
  end

  describe "overlaps?/2" do
    test "is true when two areas overlap" do
      area1 = Area.new(4, 4, 0, 0)
      area2 = Area.new(4, 4, 2, 2)

      assert Area.overlaps?(area1, area2)
    end

    test "is false when two areas do not overlap" do
      area1 = Area.new(4, 4, 0, 0)
      area2 = Area.new(4, 4, 6, 6)

      refute Area.overlaps?(area1, area2)
    end
  end
end
