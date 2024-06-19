defmodule Amalgama.Accounts.Commands.RegisterUser do
  defstruct user_uuid: "",
            username: "",
            email: "",
            password: "",
            hashed_password: ""

  use ExConstructor
  use Vex.Struct

  alias __MODULE__
  alias Amalgama.Accounts.Auth

  validates(:user_uuid, uuid: true)

  validates(:username,
    presence: [message: "can't be empty"],
    string: true,
    unique_username: true,
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"]
  )

  validates(:email,
    unique_email: true,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"]
  )

  validates(:hashed_password, presence: [message: "can't be empty"], string: true)

  defimpl Amalgama.Support.Middleware.Uniqueness.UniqueFields,
    for: Amalgama.Accounts.Commands.RegisterUser do
    def unique(_command),
      do: [
        {:username, "has already been taken"},
        {:email, "has already been taken"}
      ]
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%RegisterUser{} = register_user, uuid) do
    %RegisterUser{register_user | user_uuid: uuid}
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%RegisterUser{password: password} = register_user) do
    %RegisterUser{register_user | password: nil, hashed_password: Auth.hash_password(password)}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%RegisterUser{username: username} = register_user) do
    %RegisterUser{register_user | username: String.downcase(username)}
  end

  @doc """
  Convert email to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    %RegisterUser{register_user | email: String.downcase(email)}
  end
end
