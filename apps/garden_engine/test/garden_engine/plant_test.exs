defmodule GardenEngine.PlantTest do
  use ExUnit.Case, async: true

  alias GardenEngine.Plant

  describe "new/2" do
    test "creates a new plant with the provided values" do
      assert %Plant{name: "Green Bean", n_impact: -2, p_impact: -3, k_impact: 0} =
               Plant.new("Green Bean", n_impact: -2, p_impact: -3)
    end
  end
end
