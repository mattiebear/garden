defmodule GardenEngine.Plant do
  @moduledoc """
  Represents the taxonomic classification of a plant.
  """

  defstruct [
    :id,
    :name,
    :nitrogen_need,
    :phosphorus_need,
    :potassium_need
  ]
end
