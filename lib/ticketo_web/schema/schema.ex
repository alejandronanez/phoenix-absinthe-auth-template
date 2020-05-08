defmodule TicketoWeb.Schema.Schema do
  @moduledoc """
  GraphQL schema definition
  """
  use Absinthe.Schema
  alias TicketoWeb.Schema.Afterware
  alias TicketoWeb.Schema.Middleware
  alias TicketoWeb.Resolvers

  import_types(TicketoWeb.Schema.UserTypes)
  import_types(TicketoWeb.Schema.SessionTypes)

  query do
    @desc "Get the current user"
    field :me, :user do
      middleware(Middleware.AuthenticationRequired)
      resolve(&Resolvers.AccountsResolver.me/3)
    end
  end

  mutation do
    @desc "Login a user"
    field :login, :session do
      arg(:input, non_null(:session_input))
      middleware(Middleware.UnauthenticationRequired)
      resolve(&Resolvers.SessionResolver.login_user/3)
      middleware(Afterware.AttachTokenToResolution)
    end

    @desc "Logout a user"
    field :logout, :logout do
      middleware(Middleware.AuthenticationRequired)
      resolve(&Resolvers.SessionResolver.logout_user/3)
    end

    @desc "Refresh a token"
    field :token_refresh, :session do
      resolve(&Resolvers.SessionResolver.refresh_token/3)
      middleware(Afterware.AttachTokenToResolution)
    end

    @desc "Create an user"
    field :create_user, :session do
      arg(:input, non_null(:create_user_input))
      resolve(&Resolvers.AccountsResolver.create_user/3)
      middleware(Afterware.AttachTokenToResolution)
    end
  end
end
