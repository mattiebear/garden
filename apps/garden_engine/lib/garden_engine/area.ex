defmodule GardenEngine.EmptyArea do
  @moduledoc """
  An area with 0 size
  """

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Returns an empty area struct
  """

  @spec new() :: t()
  def new(), do: %__MODULE__{}
end

defmodule GardenEngine.Area do
  @moduledoc """
  A geometric rectangular area with width, depth, and starting coordinates.

  An area must have a width and depth both of at least 1 unit. When resolving an area,
  such as through an intersection, that does not have a width or depth it will instead
  return an `EmptyArea` struct.

  The top left coordinate is represented as `{x, y} = {0, 0}`. The x-axis increases to the right,
  and the y-axis increases downwards.
  """
  alias GardenEngine.EmptyArea

  @enforce_keys [:width, :depth, :x, :y]
  defstruct [:width, :depth, :x, :y]

  @type t :: %__MODULE__{width: pos_integer(), depth: pos_integer(), x: integer(), y: integer()}

  @doc """
  Creates a new area at position `{0,0}` with the provided dimensions
  """
  @spec new(width :: pos_integer(), depth :: pos_integer()) :: t()
  def new(width, depth) do
    new(width, depth, 0, 0)
  end

  @doc """
  Creates a new area at the provided position with the provided dimensions
  """
  @spec new(width :: pos_integer(), depth :: pos_integer(), x :: integer(), y :: integer()) :: t()
  def new(width, depth, x, y)
      when is_integer(width) and width > 0 and
             is_integer(depth) and depth > 0 and is_integer(x) and is_integer(y) do
    %__MODULE__{width: width, depth: depth, x: x, y: y}
  end

  @doc """
  Returns the intersection of two areas as a new area.

  If there is no overlap then an `EmptyArea` is returned instead.
  """

  @spec intersect(area1 :: t(), area2 :: t()) :: t() | EmptyArea.t()
  def intersect(
        %__MODULE__{x: x1, y: y1, width: w1, depth: d1} = _area1,
        %__MODULE__{x: x2, y: y2, width: w2, depth: d2} = _area2
      ) do
    left = max(x1, x2)
    top = max(y1, y2)
    right = min(x1 + w1, x2 + w2)
    bottom = min(y1 + d1, y2 + d2)

    if left < right and top < bottom do
      new(right - left, bottom - top, left, top)
    else
      %EmptyArea{}
    end
  end

  @doc """
  Returns a list of coordinates in form `{x, y}` tuples.
  """

  @spec coordinates(area :: t()) :: [{x :: integer(), y :: integer()}]
  def coordinates(%__MODULE__{x: x, y: y, width: w, depth: d}) do
    for i <- x..(x + w - 1), j <- y..(y + d - 1), do: {i, j}
  end

  @doc """
  Whether or not two areas overlap.
  """

  @spec overlaps?(area1 :: t(), area2 :: t()) :: boolean()
  def overlaps?(
        %__MODULE__{} = area1,
        %__MODULE__{} = area2
      ) do
    case intersect(area1, area2) do
      %EmptyArea{} -> false
      _ -> true
    end
  end
end
