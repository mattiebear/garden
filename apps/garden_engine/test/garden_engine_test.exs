defmodule GardenEngineTest do
  use ExUnit.Case
  doctest GardenEngine

  test "greets the world" do
    assert GardenEngine.hello() == :world
  end
end
