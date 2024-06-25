defmodule Amalgama.Blog.Aggregates.Article do
  defstruct uuid: nil,
            slug: nil,
            title: nil,
            description: nil,
            body: nil,
            tag_list: nil,
            author_uuid: nil,
            favorited_by_authors: MapSet.new(),
            favorite_count: 0

  alias Amalgama.Blog.{Aggregates, Commands, Events}

  alias Aggregates.Article
  alias Commands.{FavoriteArticle, PublishArticle, UnfavoriteArticle}
  alias Events.{ArticlePublished, ArticleFavorited, ArticleUnfavorited}

  @doc """
  Executes a command on the Article aggregate.

  ## Commands Supported:
  - `PublishArticle`: Publishes an article.
  - `FavoriteArticle`: Favorites an article for an author.
  - `UnfavoriteArticle`: Unfavorites an article for an author.

  ## Guards:
  - Guards ensure that the correct command matches the Article state.

  @param article The current state of the Article.
  @param command The command to execute.

  @returns
  - `{:ok, new_state}` if the command is successful.
  - `{:error, :article_not_found}` if the article is not found.

  ### Guards:
  - When executing `PublishArticle`:
    - Ensures the article UUID is not set.

  - When executing `FavoriteArticle` or `UnfavoriteArticle`:
    - Ensures the article UUID is set.
    - Ensures the correct command corresponds to the Article state.

  @spec execute(%Article{}, %Command{}) :: {:ok, %Article{}} | {:error, :article_not_found}
  """
  def execute(%Article{uuid: nil}, %PublishArticle{} = publish) do
    %ArticlePublished{
      article_uuid: publish.article_uuid,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tag_list: publish.tag_list,
      author_uuid: publish.author_uuid
    }
  end

  def execute(%Article{uuid: nil}, %FavoriteArticle{}), do: {:error, :article_not_found}

  def execute(
        %Article{uuid: uuid, favorite_count: favorite_count} = article,
        %FavoriteArticle{favorited_by_author_uuid: author_id}
      ) do
    case is_favorited?(article, author_id) do
      true ->
        nil

      false ->
        %ArticleFavorited{
          article_uuid: uuid,
          favorited_by_author_uuid: author_id,
          favorite_count: favorite_count + 1
        }
    end
  end

  def execute(%Article{uuid: nil}, %UnfavoriteArticle{}), do: {:error, :article_not_found}

  def execute(
        %Article{uuid: uuid, favorite_count: favorite_count} = article,
        %UnfavoriteArticle{unfavorited_by_author_uuid: author_id}
      ) do
    case is_favorited?(article, author_id) do
      true ->
        %ArticleUnfavorited{
          article_uuid: uuid,
          unfavorited_by_author_uuid: author_id,
          favorite_count: favorite_count - 1
        }

      false ->
        nil
    end
  end

  ###
  # state mutators
  ###

  def apply(%Article{} = article, %ArticlePublished{} = published) do
    %Article{
      article
      | uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_uuid: published.author_uuid
    }
  end

  def apply(
        %Article{favorited_by_authors: favorited_by} = article,
        %ArticleFavorited{favorited_by_author_uuid: author_id, favorite_count: favorite_count}
      ) do
    %Article{
      article
      | favorited_by_authors: MapSet.put(favorited_by, author_id),
        favorite_count: favorite_count
    }
  end

  def apply(
        %Article{favorited_by_authors: favorited_by} = article,
        %ArticleUnfavorited{unfavorited_by_author_uuid: author_id, favorite_count: favorite_count}
      ) do
    %Article{
      article
      | favorited_by_authors: MapSet.delete(favorited_by, author_id),
        favorite_count: favorite_count
    }
  end

  ###
  # private helpers
  ###

  # Is the article a favorite of an author?
  defp is_favorited?(%Article{favorited_by_authors: favorited_by}, author_uuid) do
    MapSet.member?(favorited_by, author_uuid)
  end
end
