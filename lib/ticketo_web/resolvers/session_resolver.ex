defmodule TicketoWeb.Resolvers.SessionResolver do
  @auth_error "Something went wrong"
  @logged_out_map %{message: "Logged out"}
  @moduledoc """
  Session Resolver. Takes care of:
  - Login users

  Should take care of:
  - Refresh tokens
  - Register users
  """
  alias Ticketo.Accounts
  alias Ticketo.Tokens.Tokens

  def login_user(_, %{input: input}, _) do
    input
    |> Accounts.authenticate()
    |> get_new_session()
  end

  def logout_user(_, _, ctx) do
    current_user =
      ctx
      |> get_current_user_id_from_context()
      |> Accounts.get_user()
      |> Accounts.update_token(%{refresh_token: ""})

    case current_user do
      {:error, _reason} ->
        {:error, @auth_error}

      {:ok, _user} ->
        {:ok, @logged_out_map}
    end
  end

  defp get_current_user_id_from_context(ctx) do
    ctx
    |> Map.get(:context, %{})
    |> Map.get(:current_user, %{})
    |> Map.get(:id, -1)
  end

  def refresh_token(_, _input, ctx) do
    with token <- ctx |> Map.get(:context) |> Map.get(:auth_token),
         {:ok, claims} <- Tokens.decode_token(token),
         {:ok, user_from_claims} <- Tokens.get_resource_from_claims(claims),
         user <- Accounts.get_user(user_from_claims.id),
         {:ok, result} <- get_new_session({:ok, user}) do
      case compare_tokens(user.refresh_token, token) do
        true -> {:ok, result}
        false -> {:error, @auth_error}
      end
    else
      _ -> {:error, @auth_error}
    end
  end

  defp compare_tokens(user_refresh_token, cookie_refresh_token)
       when is_nil(user_refresh_token) or is_nil(cookie_refresh_token) do
    false
  end

  defp compare_tokens(user_refresh_token, cookie_refresh_token) do
    String.equivalent?(user_refresh_token, cookie_refresh_token)
  end

  defp get_new_session(:error) do
    {:error, @auth_error}
  end

  defp get_new_session({:ok, user}) do
    with {:ok, jwt_token, _} <- Tokens.sign_token(user, %{type: "access"}),
         {:ok, refresh_token, _} <- Tokens.sign_token(user, %{type: "refresh"}),
         {:ok, _updated_user} <- Accounts.update_token(user, %{refresh_token: refresh_token}) do
      {:ok,
       %{
         token: jwt_token,
         refresh_token: refresh_token,
         token_expiry: Tokens.get_token_expiry(),
         user: Map.take(user, [:id, :email])
       }}
    else
      {:error, _reason} -> {:error, @auth_error}
    end
  end
end
