defmodule GardenEngine.Coordinate do
  @moduledoc """
  A single x,y coordinate
  """

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @doc """
  Creates a new coordinate from x and y values

  ## Examples

      GardenEngine.Coordinate.new(5, 3)
      %GardenEngine.Coordinate{x: 5, y: 3}
  """

  @spec new(x :: integer(), y :: integer()) :: {:ok, %__MODULE__{}} | {:error, String.t()}
  def new(x, y) do
    cond do
      not is_integer(x) -> {:error, "x must be an integer"}
      not is_integer(y) -> {:error, "y must be an integer"}
      x < 0 -> {:error, "x must be non-negative"}
      y < 0 -> {:error, "y must be non-negative"}
      true -> {:ok, %__MODULE__{x: x, y: y}}
    end
  end
end
