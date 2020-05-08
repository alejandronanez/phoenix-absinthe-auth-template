defmodule TicketoWeb.Schema.Afterware.AttachTokenToResolution do
  @moduledoc """
  Afterware that takes care of adding the `refresh_token` coming from the response from the `login` resolver
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    get_data_for_context(resolution)
  end

  defp get_data_for_context(%Absinthe.Resolution{value: %{refresh_token: token}} = resolution) do
    Map.put(resolution, :context, %{auth_token: token})
  end

  defp get_data_for_context(resolution) do
    resolution
  end
end
