# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ticketo,
  ecto_repos: [Ticketo.Repo]

# Configures the endpoint
config :ticketo, TicketoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ARqCFyW0cE8K90fkBN8SVG0SEECn4h0HRyAOPtD0wtT98GYHm6UQibbw4TC2ePAa",
  render_errors: [view: TicketoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Ticketo.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "nx/LdJ7H"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
