# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :app, App.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "1EG6uFLJAmt4oJcbu49/AwYcsZo8Oc0oWVIbJwReyGx0o3aR/sznkK/eZr17ypAT",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: App.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :exredis,
  host: "redis",
  port: 6379,
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

config :hound,
  driver: "phantomjs",
  host: "http://phantomjs",
  port: 8910,
  app_host: "http://app"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :app, riot_api_key: System.get_env("RIOT_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine
