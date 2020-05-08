defmodule TicketoWeb.Plugs.AuthHeaderToken do
  @moduledoc """
  Get the token from the the Authorization header, looks for the user assigned to that token,
  and then, assigns that user to the Absinthe Context
  """
  @behaviour Plug

  alias Plug.Conn
  alias Ticketo.Tokens.Tokens

  def init(opts) do
    opts
  end

  def call(conn, _options) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- Conn.get_req_header(conn, "authorization"),
         {:ok, claims} <- Tokens.decode_token(token),
         {:ok, user} <- Tokens.get_resource_from_claims(claims) do
      %{current_user: user, auth_token: token}
    else
      _ ->
        %{}
    end
  end
end
