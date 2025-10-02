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
end
