defmodule TicketoWeb.Router do
  use TicketoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TicketoWeb do
    pipe_through :api
  end
end
