defmodule GardenEngine.SoilSegment do
  @moduledoc """
  A representation of a 6x6 inch square segment of soil in a plot.
  The segment tracks individual nutrient levels that can be adjusted over the lifetime
  of a plant or crop within the plot.

  The tracked nutrients are:
    - Nitrogen (N)
    - Phosphorus (P)
    - Potassium (K)

  Each nutrient level is represented as a non-negative integer from 0 to 100.
  """

  defstruct [:n_level, :p_level, :k_level]

  @type t :: %__MODULE__{
          n_level: non_neg_integer(),
          p_level: non_neg_integer(),
          k_level: non_neg_integer()
        }

  @doc """
  Creates a new soil segment with the given nutrient levels.
  """

  @spec new(n :: non_neg_integer(), p :: non_neg_integer(), k :: non_neg_integer()) :: t
  def new(n, p, k) when is_integer(n) and is_integer(p) and is_integer(k) do
    %__MODULE__{
      n_level: clamp(n),
      p_level: clamp(p),
      k_level: clamp(k)
    }
  end

  @doc """
  Creates a new default balanced nutrient segment.
  """

  @spec new() :: t
  def new(), do: new(50, 50, 50)

  @doc """
  Adjusts the nitrogen level of the soil segment.
  """

  @spec adjust_nitrogen(segment :: t(), delta :: integer()) :: t()
  def adjust_nitrogen(%__MODULE__{n_level: current} = segment, delta) do
    %{segment | n_level: clamp(current + delta)}
  end

  @doc """
  Adjusts the phosphorus level of the soil segment.
  """

  @spec adjust_phosphorus(segment :: t(), delta :: integer()) :: t()
  def adjust_phosphorus(%__MODULE__{p_level: current} = segment, delta) do
    %{segment | p_level: clamp(current + delta)}
  end

  @doc """
  Adjusts the potassium level of the soil segment.
  """

  @spec adjust_potassium(segment :: t(), delta :: integer()) :: t()
  def adjust_potassium(%__MODULE__{k_level: current} = segment, delta) do
    %{segment | k_level: clamp(current + delta)}
  end

  defp clamp(value) when value < 0, do: 0
  defp clamp(value) when value > 100, do: 100
  defp clamp(value), do: value
end
