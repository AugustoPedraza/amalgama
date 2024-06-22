defmodule AmalgamaWeb.ArticleJSON do
  alias Amalgama.Blog.Projections.Article

  @doc """
  Renders a list of articles.
  """
  def index(%{articles: articles, total_count: total_count}) do
    %{data: %{articles: for(article <- articles, do: data(article)), articlesCount: total_count}}
  end

  @doc """
  Renders a single article.
  """
  def show(%{article: article}) do
    %{data: %{article: data(article)}}
  end

  defp data(%Article{} = article) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: article.tag_list,
      createdAt: NaiveDateTime.to_iso8601(article.published_at),
      updatedAt: NaiveDateTime.to_iso8601(article.updated_at),
      favoritesCount: article.favorite_count,
      favorited: false,
      author: %{
        username: article.author_username,
        bio: article.author_bio,
        image: article.author_image,
        following: false
      }
    }
  end
end
