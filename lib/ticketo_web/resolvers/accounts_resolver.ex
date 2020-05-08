defmodule TicketoWeb.Resolvers.AccountsResolver do
  @moduledoc """
  Account resolver.
  - Create accounts
  - Get current user
  """
  alias Ticketo.Accounts
  alias TicketoWeb.Resolvers.Helpers
  alias Ticketo.Tokens.Tokens

  @error_create_account "Error creating user"
  @error_current_user "Nothing here"
  @error_auth "Something went wrong"

  def me(_parent, _args, ctx) do
    current_user =
      ctx
      |> get_current_user_id_from_context()
      |> Accounts.get_user()

    case current_user do
      nil ->
        {:error, @error_current_user}

      current_user ->
        {:ok, current_user}
    end
  end

  def create_user(_parent, %{input: input}, _ctx) do
    input
    |> Accounts.create_user()
    |> handle_user_creation()
    |> get_new_session()
  end

  defp get_current_user_id_from_context(ctx) do
    ctx
    |> Map.get(:context, %{})
    |> Map.get(:current_user, %{})
    |> Map.get(:id, -1)
  end

  defp handle_user_creation({:ok, user}) do
    {:ok, user}
  end

  defp handle_user_creation({:error, error}) do
    Helpers.error_response(@error_create_account, error)
  end

  defp get_new_session({:error, _error}) do
    {:error, @error_auth}
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
      {:error, _reason} -> {:error, @error_auth}
    end
  end
end
