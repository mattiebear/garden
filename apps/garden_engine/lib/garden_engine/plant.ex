defmodule GardenEngine.Plant do
  @moduledoc """
  	A taxnomical "plant" that contains information on the growth habits,
  	nutrient impacts, and other necessary information for growing plants
  	in the garden.

  	These are only initialized as part of the plant library, which is where
  	we store the records for fetching.

   The nutrient impacts are stored as integers and represent a impact in the
   nutrient level at the height of each plant's growth cycle.
  """

  @enforce_keys [:name, :n_impact, :p_impact, :k_impact]
  defstruct [:name, :n_impact, :p_impact, :k_impact]

  @type t :: %__MODULE__{
          name: String.t(),
          n_impact: integer(),
          p_impact: integer(),
          k_impact: integer()
        }

  @doc """
  Creates a new plant with the specified attributes
  """

  @spec new(name :: String.t(), options :: Keyword.t()) :: t()
  def new(name, options \\ []) do
    %__MODULE__{
      name: name,
      n_impact: Keyword.get(options, :n_impact, 0),
      p_impact: Keyword.get(options, :p_impact, 0),
      k_impact: Keyword.get(options, :k_impact, 0)
    }
  end
end
