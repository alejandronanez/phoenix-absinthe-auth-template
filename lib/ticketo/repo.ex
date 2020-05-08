defmodule Ticketo.Repo do
  use Ecto.Repo,
    otp_app: :ticketo,
    adapter: Ecto.Adapters.Postgres
end
