defmodule GardenEngine.Garden do
  @moduledoc """
  The primary entrypoint for managing a garden.

  Through this you can create garden plots, add plants to gardens, advance time over
  all (or part) of the plots, and view details on the current nutrient and growth
  data for sections of the plots.
  """

  alias GardenEngine.Plot

  defstruct plots: %{}

  @type t :: %__MODULE__{plots: %{String.t() => Plot.t()}}

  @doc """
  Creates a new garden
  """

  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  @doc """
  Adds a new plot with the given ID
  """

  @spec add_plot(garden :: t(), id :: String.t(), plot :: Plot.t()) ::
          {:ok, t()} | {:error, String.t()}
  def add_plot(garden, id, plot) do
    if Map.has_key?(garden.plots, id) do
      {:error, "Plot with ID already exists"}
    else
      {:ok, %__MODULE__{garden | plots: Map.put(garden.plots, id, plot)}}
    end
  end
end
