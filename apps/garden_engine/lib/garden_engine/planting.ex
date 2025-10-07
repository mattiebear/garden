defmodule GardenEngine.Planting do
  @moduledoc """
  A single plant growing in a single area of space.

  This module tracks an individual plantings growth over time after it is
  added to a plot. As the plot advances in time it uses the taxonomical data
  on the plant to adjust nutrient levels in the associated area. The age of
  the plant is tracked for use in harvest prediction and long term garden
  planning.
  """

  alias GardenEngine.{Area, Plant}

  @enforce_keys [:area, :plant, :planted_on]
  defstruct [:area, :plant, :planted_on, status: :growing, nutrients_adjusted?: false]

  @typedoc """
  The stage of the planting's growth cycle. Once it reaches maturity the planting
  will either move to `:producing` if it continually yields fruits (ex. tomatoes) or
  `:finished` if it is a once time harvest (ex. lettuce).
  """
  @type stage :: :growing | :producing | :finished | :removed

  @type t :: %__MODULE__{
          area: Area.t(),
          plant: Plant.t(),
          planted_on: Date.t(),
          nutrients_adjusted?: boolean()
        }

  @doc """
  Creates a new planting
  """

  @spec new(plant :: Plant.t(), area :: Area.t(), options :: Keyword.t()) :: t()
  def new(plant, area, options \\ []) do
    planted_on = Keyword.get(options, :planted_on, Date.utc_today())

    %__MODULE__{
      area: area,
      plant: plant,
      planted_on: planted_on,
      nutrients_adjusted?: false
    }
  end

  @doc """
  Returns the current age of the planting in days
  """

  @spec age_in_days(t(), current_date :: Date.t()) :: integer()
  def age_in_days(%__MODULE__{planted_on: planted_on}, %Date{} = current_date) do
    Date.diff(current_date, planted_on)
  end

  @doc """
  Returns the current lifecycle stage of the planting
  """

  @spec current_stage(t(), current_date :: Date.t()) :: stage()
  def current_stage(%__MODULE__{plant: plant} = planting, %Date{} = current_date) do
    age = age_in_days(planting, current_date)

    cond do
      age < plant.days_to_maturity -> :growing
      age < plant.days_to_maturity + plant.days_productive -> :producing
      true -> :finished
    end
  end

  @doc """
  Informs if a nutrient adjustment should be performed for the planting area
  """

  @spec nutrient_adjustment_required?(t(), current_date :: Date.t()) :: boolean()
  def nutrient_adjustment_required?(%__MODULE__{} = planting, %Date{} = current_date) do
    current_stage(planting, current_date) != :growing and not planting.nutrients_adjusted?
  end
end
