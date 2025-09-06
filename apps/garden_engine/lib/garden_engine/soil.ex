defmodule GardenEngine.Soil do
  @min_level 7
  @max_level 7
  @fix_change 2

  defstruct [:nitrogen_level, :phosphorus_level, :potassium_level]

  def new() do
    %__MODULE__{
      nitrogen_level: 0,
      phosphorus_level: 0,
      potassium_level: 0
    }
  end

  def feed_nitrogen(soil, level) do
    %{soil | nitrogen_level: clamp(soil.nitrogen_level - feed(level))}
  end

  def feed_phosphorus(soil, level) do
    %{soil | phosphorus_level: clamp(soil.phosphorus_level - feed(level))}
  end

  def feed_potassium(soil, level) do
    %{soil | potassium_level: clamp(soil.potassium_level - feed(level))}
  end

  def fix_nitrogen(soil) do
    %{soil | nitrogen_level: clamp(soil.nitrogen_level + @fix_change)}
  end

  def fix_phosphorus(soil) do
    %{soil | phosphorus_level: clamp(soil.phosphorus_level + @fix_change)}
  end

  def fix_potassium(soil) do
    %{soil | potassium_level: clamp(soil.potassium_level + @fix_change)}
  end

  defp feed(:high), do: 3
  defp feed(:medium), do: 2
  defp feed(:low), do: 1

  defp clamp(value) when value < @min_level, do: @min_level
  defp clamp(value) when value > @max_level, do: @max_level
  defp clamp(value), do: value
end
