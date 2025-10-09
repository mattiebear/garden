defmodule GardenServer.Repo do
  use Ecto.Repo,
    otp_app: :garden_server,
    adapter: Ecto.Adapters.Postgres
end
