# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :in_stock,
  ecto_repos: [InStock.Repo]

# Configures the endpoint
config :in_stock, InStockWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YMn1Yzj5f5cY6YRVi/ea+kr9S/mVKm0syb42BgIqQNPwThipRViDHmOKBcJHuTvY",
  render_errors: [view: InStockWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: InStock.PubSub,
  live_view: [signing_salt: "yUw7/IGk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
