defmodule Amalgama.Repo do
  use Ecto.Repo,
    otp_app: :amalgama,
    adapter: Ecto.Adapters.Postgres
end
