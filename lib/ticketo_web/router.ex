defmodule TicketoWeb.Router do
  @auth_token_key "auth_token"

  use TicketoWeb, :router
  import Plug.Conn, only: [put_resp_cookie: 4]

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql_context do
    plug TicketoWeb.Plugs.AuthHeaderToken
    plug TicketoWeb.Plugs.RefreshToken
  end

  scope "/" do
    pipe_through(:api)
    pipe_through(:graphql_context)

    forward("/api", Absinthe.Plug,
      schema: TicketoWeb.Schema.Schema,
      before_send: {__MODULE__, :absinthe_before_send}
    )

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: TicketoWeb.Schema.Schema,
      before_send: {__MODULE__, :absinthe_before_send}
    )
  end

  def absinthe_before_send(conn, %Absinthe.Blueprint{} = blueprint) do
    if auth_token = blueprint.execution.context[:auth_token] do
      put_resp_cookie(conn, @auth_token_key, auth_token,
        http_only: true,
        secure: false,
        max_age: 604_800
      )
    else
      conn
    end
  end

  def absinthe_before_send(conn, _) do
    conn
  end
end
