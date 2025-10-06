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
    "tomato" =>
      Plant.new("tomato",
        n_impact: -3,
        p_impact: -2,
        k_impact: -2,
        days_to_maturity: 75,
        days_productive: 60
      )
  }

  @doc """
  Gets a specific plant by its name.
  """

  @spec get_plant(String.t()) :: {:ok, Plant.t()} | {:error, String.t()}
  def get_plant(name) do
    case Map.get(@plants, name) do
      nil -> {:error, "Plant not found"}
      plant -> {:ok, plant}
    end
  end
end
