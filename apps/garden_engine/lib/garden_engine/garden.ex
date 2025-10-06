defmodule GardenEngine.Garden do
  @moduledoc """
  The primary entrypoint for managing a garden.

  Through this you can create garden plots, add plants to gardens, advance time over
  all (or part) of the plots, and view details on the current nutrient and growth
  data for sections of the plots.
  """

  alias GardenEngine.{Area, Plant, Plot}

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
  def add_plot(%__MODULE__{} = garden, id, %Plot{} = plot) when is_binary(id) do
    if Map.has_key?(garden.plots, id) do
      {:error, "Plot with ID already exists"}
    else
      {:ok, %__MODULE__{garden | plots: Map.put(garden.plots, id, plot)}}
    end
  end

  @doc """
  Gets a garden plot by ID
  """

  @spec get_plot(garden :: t(), id :: String.t()) :: {:ok, Plot.t()} | {:error, String.t()}
  def get_plot(%__MODULE__{} = garden, id) when is_binary(id) do
    case Map.fetch(garden.plots, id) do
      {:ok, plot} -> {:ok, plot}
      :error -> {:error, "Plot with ID not found"}
    end
  end

  @doc """
  Add a new planting to a plot at the specified area
  """

  @spec add_planting(
          garden :: t(),
          plot_id :: String.t(),
          plant_id :: String.t(),
          plant :: Plant.t(),
          area :: Area.t()
        ) ::
          {:ok, t()} | {:error, String.t()}
  def add_planting(%__MODULE__{} = garden, plot_id, plant_id, %Plant{} = plant, %Area{} = area)
      when is_binary(plot_id) and is_binary(plant_id) do
    with {:ok, plot} <- get_plot(garden, plot_id),
         {:ok, plot} <- Plot.add_planting(plot, plant_id, plant, area) do
      {:ok, %__MODULE__{garden | plots: Map.put(garden.plots, plot_id, plot)}}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
