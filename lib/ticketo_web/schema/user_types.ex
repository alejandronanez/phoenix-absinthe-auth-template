defmodule TicketoWeb.Schema.UserTypes do
  @moduledoc """
  User schema types
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
  end

  input_object :create_user_input do
    field :email, :string
    field :password, :string
  end
end
