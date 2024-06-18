defmodule Amalgama.Accounts do
  @moduledoc """
  The boundary for the Accounts domain.
  """

  alias Amalgama.Accounts.Commands.RegisterUser
  alias Amalgama.Accounts.Projections.User
  alias Amalgama.{Repo, CommandedApp}

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    attrs
    |> Map.put(:user_uuid, uuid)
    |> RegisterUser.new()
    |> CommandedApp.dispatch(consistency: :strong)
    |> case do
      :ok -> get(User, uuid)
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
