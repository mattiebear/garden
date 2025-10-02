defmodule GardenEngine.PlantLibraryTest do
  use ExUnit.Case, async: true

  alias GardenEngine.{Plant, PlantLibrary}

  describe "get_plant/1" do
    test "returns the requested plant" do
      assert PlantLibrary.get_plant("tomato") == %Plant{
               name: "tomato",
               n_impact: -3,
               p_impact: -2,
               k_impact: -2
             }
    end

    test "returns nil if the plant does not exist" do
      assert PlantLibrary.get_plant("banana") == nil
    end
  end
end
