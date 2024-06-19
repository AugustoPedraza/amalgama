defmodule Amalgama.Router do
  use Commanded.Commands.Router

  alias Amalgama.Accounts.Aggregates.User
  alias Amalgama.Accounts.Commands.RegisterUser
  alias Amalgama.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  dispatch([RegisterUser], to: User, identity: :user_uuid)
end
