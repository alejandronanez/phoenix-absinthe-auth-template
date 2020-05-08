defmodule TicketoWeb.Plugs.RefreshToken do
  @moduledoc """
  Idenfity if the request is a `tokenRefresh` mutation and let it continue.

  Getting all the data from the token should happen at the resolver/context level
  not in the plug as this will log the user back in and we don't want that.
  """
  @behaviour Plug

  alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(%{body_params: _body_params = %{"query" => query}} = conn, _options) do
    # Refresh token - put the authorization in the cookie in the Absinthe execution context
    case query =~ "tokenRefresh" do
      true ->
        with refresh_token <- get_auth_token_from_cookie(conn) do
          Absinthe.Plug.put_options(conn, context: %{auth_token: refresh_token})
        end

      false ->
        conn
    end
  end

  def call(conn, _options) do
    conn
  end

  defp get_auth_token_from_cookie(conn) do
    conn
    |> Conn.fetch_cookies()
    |> Map.get(:req_cookies)
    |> Map.get("auth_token")
  end
end
