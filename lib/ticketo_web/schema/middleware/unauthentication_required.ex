defmodule TicketoWeb.Schema.Middleware.UnauthenticationRequired do
  @moduledoc """
  Middleware used to prevent the usage of public endpoints if the user is logged in (create accoun, login, etc)
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} ->
        resolution |> Absinthe.Resolution.put_result({:error, "Forbidden"})

      _ ->
        resolution
    end
  end
end
