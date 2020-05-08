defmodule TicketoWeb.Schema.SessionTypes do
  @moduledoc """
  Session schema types
  """
  use Absinthe.Schema.Notation

  object :session do
    field :token, :string
    field :token_expiry, :integer
    field :user, :user
  end

  object :logout do
    field :message, :string
  end

  input_object :session_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  input_object :token_refresh_input do
    field(:token, non_null(:string))
    field(:token_expiry, non_null(:integer))
  end
end
