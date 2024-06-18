defmodule Amalgama.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "accounts_users" do
    field :image, :string
    field :username, :string
    field :email, :string
    field :hashed_password, :string
    field :bio, :string

    timestamps(type: :utc_datetime)
  end
end
