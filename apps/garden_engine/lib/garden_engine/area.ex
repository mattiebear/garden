defmodule GardenEngine.Area do
  @moduledoc """
  A 2D grid area
  """

  alias GardenEngine.Coordinate

  defstruct [:top_left_anchor, :bottom_right_anchor]

  def new(%Coordinate{} = top_left_anchor, %Coordinate{} = bottom_right_anchor) do
    %__MODULE__{
      top_left_anchor: top_left_anchor,
      bottom_right_anchor: bottom_right_anchor
    }
  end
end
