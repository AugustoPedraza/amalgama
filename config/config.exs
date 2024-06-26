# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :amalgama,
  ecto_repos: [Amalgama.Repo],
  generators: [timestamp_type: :utc_datetime]

config :amalgama, Amalgama.Repo,
  stacktrace: true,
  migration_primary_key: [name: :uuid, type: :uuid],
  show_sensitive_data_on_connection_error: true,
  username: System.get_env("PGUSER"),
  database: System.get_env("PGDATABASE"),
  password: System.get_env("PGPASSWORD"),
  hostname: System.get_env("PGHOST"),
  port: System.get_env("PGPORT"),
  pool_size: 10

# Configures the endpoint
config :amalgama, AmalgamaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AmalgamaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Amalgama.PubSub,
  live_view: [signing_salt: "LMpNsfpq"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :amalgama, Amalgama.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  amalgama: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  amalgama: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :amalgama, Amalgama.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Amalgama.EventStore
  ],
  pubsub: :local,
  registry: :local

config :amalgama, Amalgama.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  hostname: System.get_env("PGHOST"),
  port: System.get_env("PGPORT"),
  pool_size: 10

config :commanded_ecto_projections, repo: Amalgama.Repo
config :amalgama, event_stores: [Amalgama.EventStore]

config :vex,
  sources: [
    Amalgama.Support.Validators,
    Amalgama.Accounts.Validators,
    Amalgama.Blog.Validators,
    Vex.Validators
  ]

config :amalgama, Amalgama.Auth.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Amalgama",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "R+pkl4FlEVeDSFm/mgcD3MPMTP0yNebtXSYx8kFrz9Ci9Bt/MK0FdmXZvgFC4l5Y"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
