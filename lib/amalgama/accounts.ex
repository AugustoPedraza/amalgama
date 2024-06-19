defmodule Amalgama.Accounts do
  @moduledoc """
  The boundary for the Accounts domain.
  """

  alias Amalgama.Accounts.Queries.{UserByUsername, UserByEmail}
  alias Amalgama.Accounts.Commands.RegisterUser
  alias Amalgama.Accounts.Projections.User
  alias Amalgama.{Repo, CommandedApp}

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    attrs
    |> RegisterUser.new()
    |> RegisterUser.assign_uuid(uuid)
    |> RegisterUser.downcase_username()
    |> RegisterUser.downcase_email()
    |> RegisterUser.hash_password()
    |> CommandedApp.dispatch(consistency: :strong)
    |> case do
      :ok -> get(User, uuid)
      reply -> reply
    end
  end

  @doc """
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) do
    username
    |> String.downcase()
    |> UserByUsername.new()
    |> Repo.one()
  end

  @doc """
  Get an existing user by their email, or return `nil` if not registered
  """
  def user_by_email(username) do
    username
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
