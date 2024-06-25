defmodule Amalgama.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Amalgama.CommandedApp,
    repo: Amalgama.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Amalgama.Blog.Events.{
    ArticlePublished,
    AuthorCreated,
    ArticleFavorited,
    ArticleUnfavorited
  }

  alias Amalgama.Blog.Projections.{Author, Article, FavoritedArticle}

  project(%AuthorCreated{} = author, _medatada, fn multi ->
    Ecto.Multi.insert(multi, :user, %Author{
      uuid: author.author_uuid,
      user_uuid: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil
    })
  end)

  project(%ArticlePublished{} = published, %{created_at: published_at} = _medatada, fn multi ->
    multi
    |> Ecto.Multi.run(:author, fn repo, _changes -> get_author(repo, published.author_uuid) end)
    |> Ecto.Multi.run(:article, fn repo, %{author: author} ->
      article = %Article{
        uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        favorite_count: 0,
        published_at: DateTime.truncate(published_at, :second),
        author_uuid: author.uuid,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image
      }

      repo.insert(article)
    end)
  end)

  @doc """
  Update favorite count when an article is favorited
  """
  project(
    %ArticleFavorited{
      article_uuid: article_uuid,
      favorited_by_author_uuid: favorited_by_author_uuid,
      favorite_count: favorite_count
    },
    _medatada,
    fn multi ->
      multi
      |> Ecto.Multi.insert(:favorited_article, %FavoritedArticle{
        article_uuid: article_uuid,
        favorited_by_author_uuid: favorited_by_author_uuid
      })
      |> Ecto.Multi.update_all(:article, article_query(article_uuid),
        set: [
          favorite_count: favorite_count
        ]
      )
    end
  )

  @doc """
  Update favorite count when an article is unfavorited
  """
  project(
    %ArticleUnfavorited{
      article_uuid: article_uuid,
      unfavorited_by_author_uuid: unfavorited_by_author_uuid,
      favorite_count: favorite_count
    },
    _meta,
    fn multi ->
      multi
      |> Ecto.Multi.delete_all(
        :favorited_article,
        favorited_article_query(article_uuid, unfavorited_by_author_uuid)
      )
      |> Ecto.Multi.update_all(:article, article_query(article_uuid),
        set: [
          favorite_count: favorite_count
        ]
      )
    end
  )

  defp article_query(article_uuid) do
    from(a in Article, where: a.uuid == ^article_uuid)
  end

  defp favorited_article_query(article_uuid, author_uuid) do
    from(f in FavoritedArticle,
      where: f.article_uuid == ^article_uuid and f.favorited_by_author_uuid == ^author_uuid
    )
  end

  defp get_author(repo, uuid) do
    case repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
