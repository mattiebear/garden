defmodule GardenEngine.PlantCatalog do
  @moduledoc """
  The catalog of available plants that can be added to a garden
  """

  alias GardenEngine.Plant

  @plants %{
    "tomato" => %Plant{
      id: "tomato",
      name: "Tomato",
      nitrogen_need: :high,
      phosphorus_need: :high,
      potassium_need: :high
    },
    "broccoli" => %Plant{
      id: "broccoli",
      name: "Broccoli",
      nitrogen_need: :high,
      phosphorus_need: :medium,
      potassium_need: :high
    },
    "cucumber" => %Plant{
      id: "cucumber",
      name: "Cucumber",
      nitrogen_need: :medium,
      phosphorus_need: :medium,
      potassium_need: :high
    },
    "bell_pepper" => %Plant{
      id: "bell_pepper",
      name: "Bell Pepper",
      nitrogen_need: :medium,
      phosphorus_need: :high,
      potassium_need: :high
    },
    "jalapeno" => %Plant{
      id: "jalapeno",
      name: "Jalapeño",
      nitrogen_need: :medium,
      phosphorus_need: :high,
      potassium_need: :high
    }
  }

  @doc """
  Finds a single plant by id

  ## Examples

      iex> GardenEngine.PlantCatalog.get_plant("tomato")
      %Plant{id: "tomato", name: "Tomato"}
  """
  def get_plant(id) do
    Map.get(@plants, id)
  end

  @doc """
  Returns all plants in the catalog by id

  ## Examples

      iex> GardenEngine.PlantCatalog.get_all_plants()
      %{
        "tomato" => %Plant{id: "tomato", name: "Tomato"},
        "broccoli" => %Plant{id: "broccoli", name: "Broccoli"},
        "cucumber" => %Plant{id: "cucumber", name: "Cucumber"},
      }
  """
  def get_all_plants do
    @plants
  end

  @doc """
  Lists all plants

  ## Examples

      iex> GardenEngine.PlantCatalog.list_plants()
      [%Plant{id: "tomato", name: "Tomato"}, %Plant{id: "broccoli", name: "Broccoli"}]
  """
  def list_plants do
    Map.values(@plants)
  end
end
