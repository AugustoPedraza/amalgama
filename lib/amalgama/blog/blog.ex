defmodule Amalgama.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Amalgama.{CommandedApp, Blog, Repo}
  alias Blog.{Commands, Projections, Queries}

  alias Queries.ArticleBySlug

  alias Commands.{CreateAuthor, PublishArticle}
  alias Projections.{Author, Article}

  @doc """
  Get the author for a given uuid.
  """
  def get_author!(uuid) do
    Repo.get!(Author, uuid)
  end

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

  @doc """
  Get an article by its URL slug, or return `nil` if not found.
  """
  def article_by_slug(slug) do
    slug
    |> String.downcase()
    |> ArticleBySlug.new()
    |> Repo.one()
  end

  @doc """
  Publishes an article by the given author.
  """
  def publish_article(%Author{} = author, attrs \\ %{}) do
    uuid = UUID.uuid4()

    publish_article =
      attrs
      |> PublishArticle.new()
      |> PublishArticle.assign_uuid(uuid)
      |> PublishArticle.assign_author(author)
      |> PublishArticle.generate_url_slug()

    with :ok <- CommandedApp.dispatch(publish_article, consistency: :strong) do
      get(Article, uuid)
    else
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
