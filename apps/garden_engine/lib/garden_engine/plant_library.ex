defmodule GardenEngine.PlantLibrary do
  @moduledoc """
  The library of plants available to add to a gardent plot. This contains
  all of the information needed on a plant/crop to track its growth and
  nutrient needs over time.

  These represent only basic taxonomical data. For example, although there
  are many types of tomatoes there is only one available "tomato" plant after
    this time.
  """

  alias GardenEngine.Plant

  @plants %{
    "tomato" => Plant.new("tomato", n_impact: -3, p_impact: -2, k_impact: -2),
    "beans" => Plant.new("beans", n_impact: +2, p_impact: -1, k_impact: -1)
  }

  @doc """
  Gets a specific plant by its name.
  """

  @spec get_plant(String.t()) :: Plant.t() | nil
  def get_plant(name) do
    Map.get(@plants, name)
  end
end
