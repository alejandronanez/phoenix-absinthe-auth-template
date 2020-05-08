defmodule TicketoWeb.Schema.Middleware.AuthenticationRequired do
  @moduledoc """
  Middleware used to secure all private endpoints
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Please sign in first!"})
    end
  end
end
