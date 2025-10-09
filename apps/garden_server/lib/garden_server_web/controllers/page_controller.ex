defmodule GardenServerWeb.PageController do
  use GardenServerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
