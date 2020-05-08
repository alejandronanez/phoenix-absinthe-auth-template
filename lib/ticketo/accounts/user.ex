defmodule Ticketo.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :refresh_token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    required_fields = [:email, :password]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> hash_password()
  end

  def insert_token_changeset(user, attrs) do
    required_fields = [:refresh_token]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end

  def reset_token_changeset(user, attrs) do
    required_fields = [:refresh_token]

    user
    |> cast(attrs, required_fields)
    |> validate_length(:refresh_token, is: 0)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
