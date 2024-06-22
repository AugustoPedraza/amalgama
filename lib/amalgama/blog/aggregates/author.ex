defmodule Amalgama.Blog.Aggregates.Author do
  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :bio,
    :image
  ]

  alias __MODULE__
  alias Amalgama.Blog.Commands.CreateAuthor
  alias Amalgama.Blog.Events.AuthorCreated

  @doc """
  Creates an author
  """
  def execute(%Author{uuid: nil}, %CreateAuthor{} = create) do
    %AuthorCreated{
      author_uuid: create.author_uuid,
      user_uuid: create.user_uuid,
      username: create.username
    }
  end

  # state mutators

  def apply(%Author{} = author, %AuthorCreated{} = created) do
    %Author{
      author
      | uuid: created.author_uuid,
        user_uuid: created.user_uuid,
        username: created.username
    }
  end
end
