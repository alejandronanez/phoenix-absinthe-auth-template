defmodule Ticketo.Guardian do
  @moduledoc false
  use Guardian, otp_app: :ticketo
  alias Ticketo.Accounts

  def subject_for_token(nil, nil) do
    {:error, :reason_for_error}
  end

  def subject_for_token(%Accounts.User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(nil) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil ->
        {:error, :resource_not_found}

      user ->
        current_user = Map.take(user, [:id, :email])
        {:ok, current_user}
    end
  end
end
