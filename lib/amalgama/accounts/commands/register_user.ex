defmodule Amalgama.Accounts.Commands.RegisterUser do
  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password
  ]

  use ExConstructor
  use Vex.Struct

  alias __MODULE__

  validates(:user_uuid, uuid: true)

  validates(:username,
    presence: [message: "can't be empty"],
    string: true,
    unique_username: true,
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true)
  validates(:hashed_password, presence: [message: "can't be empty"], string: true)

  defimpl Amalgama.Support.Middleware.Uniqueness.UniqueFields,
    for: Amalgama.Accounts.Commands.RegisterUser do
    def unique(_command),
      do: [
        {:username, "has already been taken"}
      ]
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%RegisterUser{} = register_user, uuid) do
    %RegisterUser{register_user | user_uuid: uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%RegisterUser{username: username} = register_user) do
    %RegisterUser{register_user | username: String.downcase(username)}
  end
end
