defmodule Amalgama.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Amalgama.CommandedApp,
    repo: Amalgama.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Amalgama.Blog.Events.{ArticlePublished, AuthorCreated}
  alias Amalgama.Blog.Projections.{Author, Article}

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

  defp get_author(repo, uuid) do
    case repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
