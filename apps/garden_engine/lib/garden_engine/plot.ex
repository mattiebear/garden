defmodule GardenEngine.Plot do
  alias GardenEngine.{Area, SoilSegment}

  @moduledoc """
  A single garden plot.

  A plot contains numerous plantings and is arranged in a grid structure of
  soil segments. Each individual planting relates to a plant that tracks
  its growth over time. As we advance time on the plot each of the plantings
  age and also deplete the soil of the individual soil segments.
  """

  @enforce_keys [:area]
  defstruct area: nil, segments: %{}

  @doc """
  Creates a new plot with the provided dimensions.
  """

  def new(width, depth) do
    area = Area.new(width, depth)
    segments = initialize_segments(area)
    %__MODULE__{area: area, segments: segments}
  end

  defp initialize_segments(area) do
    area
    |> Area.coordinates()
    |> Enum.into(%{}, fn coord -> {coord, SoilSegment.new()} end)
  end
end
