defmodule AmalgamaWeb.ArticleJSON do
  alias Amalgama.Blog.Article

  @doc """
  Renders a list of articles.
  """
  def index(%{articles: articles}) do
    %{data: for(article <- articles, do: data(article))}
  end

  @doc """
  Renders a single article.
  """
  def show(%{article: article}) do
    %{data: data(article)}
  end

  defp data(%Article{} = article) do
    %{
      id: article.id,
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tag_list: article.tag_list,
      favorite_count: article.favorite_count,
      published_at: article.published_at,
      author_uuid: article.author_uuid,
      author_username: article.author_username,
      author_bio: article.author_bio,
      author_image: article.author_image
    }
  end
end
