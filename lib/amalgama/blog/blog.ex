defmodule Amalgama.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Amalgama.{CommandedApp, Blog, Repo, Router}
  alias Blog.{Commands, Projections}

  alias Commands.CreateAuthor
  alias Projections.Author

  @doc """
  Create an author.
  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    attrs
    |> CreateAuthor.new()
    |> CreateAuthor.assign_uuid(uuid)
    |> CommandedApp.dispatch(consistency: :strong)
    |> case do
      :ok -> get(Author, uuid)
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
