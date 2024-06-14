defmodule Amalgama.Accounts.Events.UserRegistered do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :username,
    :email,
    :hashed_password
  ]
end
