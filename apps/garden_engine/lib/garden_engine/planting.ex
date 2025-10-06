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

  @enforce_keys [:area, :plant, :planted_on]
  defstruct [:area, :plant, :planted_on]

  @type t :: %__MODULE__{area: Area.t(), plant: Plant.t(), planted_on: Date.t()}

  @doc """
  Creates a new planting
  """

  @spec new(plant :: Plant.t(), area :: Area.t(), options :: Keyword.t()) :: t()
  def new(plant, area, options \\ []) do
    planted_on = Keyword.get(options, :planted_on, Date.utc_today())
    %__MODULE__{area: area, plant: plant, planted_on: planted_on}
  end

  @doc """
  Returns the current age of the planting in days
  """
  @spec age(t(), current_day :: Date.t()) :: integer()
  def age(%__MODULE__{planted_on: planted_on}, %Date{} = current_day) do
    Date.diff(current_day, planted_on)
  end
end
