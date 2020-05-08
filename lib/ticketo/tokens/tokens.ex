defmodule Ticketo.Tokens.Tokens do
  @moduledoc """
  Abstraction around token signing/decoding/etc
  I felt that this was scattered in the Guardian File, so this should hold up all the token logic
  """
  alias Ticketo.Guardian

  @doc """
  Create the access token
  """
  def sign_token(user, %{type: "access"}) do
    Guardian.encode_and_sign(user, %{}, ttl: {10, :minutes})
  end

  @doc """
  Create the refresh token
  """
  def sign_token(user, %{type: "refresh"}) do
    Guardian.encode_and_sign(user, %{}, ttl: {1, :weeks}, token_type: "refresh")
  end

  @doc """
  Decode the token
  """
  def decode_token(token) do
    Guardian.decode_and_verify(token)
  end

  def get_resource_from_claims(claims) do
    Guardian.resource_from_claims(claims)
  end

  def get_token_expiry() do
    Calendar.DateTime.now_utc()
    |> Calendar.DateTime.add!(3_600 * 24 * 7)
    |> Calendar.DateTime.Format.js_ms()
  end
end
