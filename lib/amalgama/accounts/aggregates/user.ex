defmodule Amalgama.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password
  ]

  alias Amalgama.Accounts.{
    Aggregates,
    Commands,
    Events
  }

  alias Aggregates.User
  alias Commands.RegisterUser
  alias Events.UserRegistered

  @doc """
   Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register_cmd) do
    %UserRegistered{
      user_uuid: register_cmd.user_uuid,
      username: register_cmd.username,
      email: register_cmd.email,
      hashed_password: register_cmd.hashed_password
    }
  end

  # state mutators
  def apply(%User{} = user, %UserRegistered{} = registered_event) do
    %User{
      user
      | uuid: registered_event.user_uuid,
        username: registered_event.username,
        email: registered_event.email,
        hashed_password: registered_event.hashed_password
    }
  end
end
