defmodule GardenEngine.Soil do
  @moduledoc """
  An individual space of soil within a plot. Represents a 6" square of dirt.
  """

  @min_level -7
  @max_level 7
  @fix_change 2
  @requirement_levels [:high, :medium, :low]

  defstruct nitrogen_level: 0, phosphorus_level: 0, potassium_level: 0

  def new() do
    %__MODULE__{
      nitrogen_level: 0,
      phosphorus_level: 0,
      potassium_level: 0
    }
  end

  @doc """
  Applies nitrogen nutrient depletion to soil

  ## Examples

      iex> soil = %Soil{nitrogen_level: 5}
      iex> GardenEngine.Soil.feed_nitrogen(soil, :high)
      %Soil{nitrogen_level: 2}
  """

  def feed_nitrogen(%__MODULE__{} = soil, level) when level in @requirement_levels do
    %{soil | nitrogen_level: clamp(soil.nitrogen_level - feed(level))}
  end

  # TODO: Add more docs

  def feed_phosphorus(%__MODULE__{} = soil, level) when level in @requirement_levels do
    %{soil | phosphorus_level: clamp(soil.phosphorus_level - feed(level))}
  end

  def feed_potassium(%__MODULE__{} = soil, level) when level in @requirement_levels do
    %{soil | potassium_level: clamp(soil.potassium_level - feed(level))}
  end

  def fix_nitrogen(%__MODULE__{} = soil) do
    %{soil | nitrogen_level: clamp(soil.nitrogen_level + @fix_change)}
  end

  def fix_phosphorus(%__MODULE__{} = soil) do
    %{soil | phosphorus_level: clamp(soil.phosphorus_level + @fix_change)}
  end

  def fix_potassium(%__MODULE__{} = soil) do
    %{soil | potassium_level: clamp(soil.potassium_level + @fix_change)}
  end

  defp feed(:high), do: 3
  defp feed(:medium), do: 2
  defp feed(:low), do: 1

  defp clamp(value) when value < @min_level, do: @min_level
  defp clamp(value) when value > @max_level, do: @max_level
  defp clamp(value), do: value
end
