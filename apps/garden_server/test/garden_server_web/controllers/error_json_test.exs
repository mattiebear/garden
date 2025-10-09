defmodule GardenServerWeb.ErrorJSONTest do
  use GardenServerWeb.ConnCase, async: true

  test "renders 404" do
    assert GardenServerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert GardenServerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
