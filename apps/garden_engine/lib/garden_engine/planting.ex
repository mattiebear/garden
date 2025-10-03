defmodule GardenEngine.Planting do
  @moduledoc """
  A single plant growing in a single area of space.

  This module tracks an individual plantings growth over time after it is
  added to a plot. As the plot advances in time it uses the taxonomical data
  on the plant to adjust nutrient levels in the associated area. The age of
  the plant is tracked for use in harvest prediction and long term garden
  planning.
  """

  alias GardenEngine.{Area, Plant}

  @enforce_keys [:area, :plant]
  defstruct [:area, :plant, age: 0]

  @type t :: %__MODULE__{area: Area.t(), plant: Plant.t()}

  @doc """
  Creates a new planting
  """

  @spec new(plant :: Plant.t(), area :: Area.t(), options :: Keyword.t()) :: t()
  def new(plant, area, options \\ []) do
    age = Keyword.get(options, :age, 0)
    %__MODULE__{area: area, plant: plant, age: age}
  end
end
