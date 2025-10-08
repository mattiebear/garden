defmodule GardenEngine.Plot do
  @moduledoc """
  A single garden plot.

  A plot contains numerous plantings and is arranged in a grid structure of
  soil segments. Each individual planting relates to a plant that tracks
  its growth over time. As we advance time on the plot each of the plantings
  age and also deplete the soil of the individual soil segments.
  """

  alias GardenEngine.{Area, Plant, Planting, SoilSegment}

  @enforce_keys [:area]
  defstruct area: nil, segments: %{}, plantings: %{}

  @type t :: %__MODULE__{
          area: Area.t(),
          segments: %{Area.coord() => SoilSegment.t()},
          plantings: %{String.t() => Planting.t()}
        }

  @doc """
  Creates a new plot with the provided dimensions.
  """

  def new(width, depth) do
    area = Area.new(width, depth)
    segments = initialize_segments(area)
    %__MODULE__{area: area, segments: segments}
  end

  defp initialize_segments(area) do
    area
    |> Area.coordinates()
    |> Enum.into(%{}, fn coord -> {coord, SoilSegment.new()} end)
  end

  @doc """
  Adds a plant to the plot within the specified area.

  As the plant grows it will deplete (or fix) nitrients in the soil segments
  within the area. At this time plant areas cannot overlap.
  """

  @spec add_planting(
          plot :: t(),
          id :: String.t(),
          plant :: GardenEngine.Plant.t(),
          area :: GardenEngine.Area.t()
        ) :: {:ok, t()} | {:error, String.t()}
  def add_planting(%__MODULE__{} = plot, id, %Plant{} = plant, %Area{} = area)
      when is_binary(id) do
    cond do
      plot_exists?(plot, id) ->
        {:error, "Planting already exists with provided ID"}

      area_occupied?(plot, area) ->
        {:error, "Area already occupied"}

      true ->
        planting = Planting.new(plant, area)
        {:ok, %{plot | plantings: Map.put(plot.plantings, id, planting)}}
    end
  end

  @doc """
  Advances the plot to the provided date and applies nutrient adjustments when
  necessary.
  """

  @spec advance(plot :: t(), date :: Date.t()) :: t()
  def advance(%__MODULE__{} = plot, %Date{} = date) do
    {updated_plantings, adjustments} =
      Enum.map_reduce(plot.plantings, [], fn {id, planting}, adjustments_acc ->
        if not Planting.nutrient_adjustment_required?(planting, date) do
          {{id, planting}, adjustments_acc}
        else
          updated_planting = %{planting | nutrients_adjusted?: true}
          {{id, updated_planting}, [planting | adjustments_acc]}
        end
      end)

    updated_segments = apply_soil_adjustments(plot.segments, adjustments)
    %{plot | plantings: Map.new(updated_plantings), segments: updated_segments}
  end

  defp area_occupied?(plot, area) do
    plot.plantings
    |> Map.values()
    |> Enum.any?(fn planting -> Area.overlaps?(planting.area, area) end)
  end

  defp plot_exists?(plot, id) do
    Map.has_key?(plot.plantings, id)
  end

  defp apply_soil_adjustments(segments, plantings) do
    Enum.reduce(plantings, segments, fn planting, acc ->
      coords = Area.coordinates(planting.area)

      Enum.reduce(coords, acc, fn {x, y}, acc ->
        Map.update!(acc, {x, y}, fn segment ->
          segment
          |> SoilSegment.adjust_nitrogen(planting.plant.n_impact)
          |> SoilSegment.adjust_phosphorus(planting.plant.p_impact)
          |> SoilSegment.adjust_potassium(planting.plant.k_impact)
        end)
      end)
    end)
  end
end
