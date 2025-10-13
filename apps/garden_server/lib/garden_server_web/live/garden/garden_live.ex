defmodule GardenServerWeb.Garden.GardenLive do
  use GardenServerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>Garden</div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
