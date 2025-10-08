defmodule GardenEngine.Garden do
  @moduledoc """
  The primary entrypoint for managing a garden.

  Through this you can create garden plots, add plants to gardens, advance time over
  all (or part) of the plots, and view details on the current nutrient and growth
  data for sections of the plots.
  """

  alias GardenEngine.{Area, Plant, Plot}

  defstruct [:current_date, plots: %{}]

  @type t :: %__MODULE__{plots: %{String.t() => Plot.t()}}

  @doc """
  Creates a new garden
  """

  @spec new(options :: keyword()) :: t()
  def new(options \\ []) do
    current_date = Keyword.get(options, :current_date, Date.utc_today())
    %__MODULE__{current_date: current_date}
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

  @doc """
  Advances all plots and plants in the garden to a new date. All plants that have reached maturity
  will additionally trigger nutrient depletions or growths in the associated soil segements
  within each plot.
  """

  @spec advance(garden :: t(), date :: Date.t()) :: {:ok, t()} | {:error, String.t()}
  def advance(%__MODULE__{} = garden, %Date{} = date) do
    case Date.diff(date, garden.current_date) do
      days when days > 0 ->
        {:ok, advance_garden_to_date(garden, date)}

      days when days == 0 ->
        {:ok, garden}

      _ ->
        {:error, "Can't advance to a date in the past"}
    end
  end

  defp advance_garden_to_date(garden, date) do
    updated_plots =
      garden.plots
      |> Enum.map(fn {id, plot} ->
        {id, Plot.advance(plot, date)}
      end)
      |> Enum.into(%{})

    %{garden | plots: updated_plots}
  end
end
