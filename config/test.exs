import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :amalgama, Amalgama.Repo,
  database: "amalgama_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :amalgama, AmalgamaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yZX0+gPDvcUvWMqO7LS/zX3IsVWM/PYCfrFbo/vgL6J+mbNXKJXi2MXqImpSnhY4",
  server: false

# In test we don't send emails.
config :amalgama, Amalgama.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

config :amalgama, Amalgama.EventStore, database: "amalgama_eventstore_test"

config :bcrypt_elixir, log_rounds: 4
