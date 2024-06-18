defmodule Amalgama.Router do
  use Commanded.Commands.Router

  alias Amalgama.Accounts.Aggregates.User
  alias Amalgama.Accounts.Commands.RegisterUser

  dispatch([RegisterUser], to: User, identity: :user_uuid)
end
