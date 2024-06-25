defmodule Amalgama.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Amalgama.Accounts.Projections.User
  alias Amalgama.{CommandedApp, Blog, Repo}
  alias Blog.{Commands, Projections, Queries}

  alias Queries.{ArticleBySlug, ListArticles}

  alias Commands.{CreateAuthor, FavoriteArticle, PublishArticle, UnfavoriteArticle}
  alias Projections.{Author, Article}

  @doc """
  Get the author for a given uuid, or raise an `Ecto.NoResultsError` if not found.
  """
  def get_author!(uuid), do: Repo.get!(Author, uuid)

  @doc """
  Get the author for a given uuid, or nil if the user is nil.
  """
  def get_author(nil), do: nil
  def get_author(%User{uuid: user_uuid}), do: get_author(user_uuid)
  def get_author(uuid) when is_bitstring(uuid), do: Repo.get(Author, uuid)

  @doc """
  Get an article by its URL slug, or return `nil` if not found
  """
  def article_by_slug(slug),
    do: article_by_slug_query(slug) |> Repo.one()

  @doc """
  Get an article by its URL slug, or raise an `Ecto.NoResultsError` if not found.
  """
  def article_by_slug!(slug),
    do: article_by_slug_query(slug) |> Repo.one!()

  @doc """
  Returns most recent articles globally by default.

  Provide tag, author or favorited query parameter to filter results.
  """
  @spec list_articles(params :: map(), author :: Author.t()) ::
          {articles :: list(Article.t()), article_count :: non_neg_integer()}
  def list_articles(params \\ %{}, author \\ nil)

  def list_articles(params, author) do
    ListArticles.paginate(params, author, Repo)
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

  @doc """
  Favorite the article for an author
  """
  def favorite_article(%Author{} = author, %Article{} = article) do
    cmd =
      %{}
      |> FavoriteArticle.new()
      |> FavoriteArticle.assign_article(article)
      |> FavoriteArticle.assign_favoriting_author(author)

    with :ok <- CommandedApp.dispatch(cmd, consistency: :strong),
         {:ok, article} <- get(Article, article.uuid) do
      {:ok, %Article{article | favorited: true}}
    else
      reply -> reply
    end
  end

  # @doc """
  # Unfavorite the article for an author
  # """
  def unfavorite_article(%Author{} = author, %Article{} = article) do
    cmd =
      %{}
      |> UnfavoriteArticle.new()
      |> UnfavoriteArticle.assign_article(article)
      |> UnfavoriteArticle.assign_unfavoriting_author(author)

    with :ok <- CommandedApp.dispatch(cmd, consistency: :strong),
         {:ok, article} <- get(Article, article.uuid) do
      {:ok, %Article{article | favorited: false}}
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

  defp article_by_slug_query(slug) do
    slug
    |> String.downcase()
    |> ArticleBySlug.new()
  end
end
