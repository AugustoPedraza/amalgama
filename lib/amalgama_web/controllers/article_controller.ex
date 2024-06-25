defmodule AmalgamaWeb.ArticleController do
  use AmalgamaWeb, :controller

  alias Amalgama.Blog
  alias Blog.Projections.Article

  plug Guardian.Plug.EnsureAuthenticated when action in [:create]
  plug Guardian.Plug.LoadResource when action in [:create]

  action_fallback AmalgamaWeb.FallbackController

  def index(%{private: private} = conn, params) do
    author = Blog.get_author(private[:guardian_current_user_resource])
    {articles, total_count} = Blog.list_articles(params, author)
    render(conn, :index, articles: articles, total_count: total_count)
  end

  def create(%{private: %{guardian_current_user_resource: current_user}} = conn, %{
        "article" => article_params
      }) do
    author = Blog.get_author!(current_user.uuid)

    with {:ok, %Article{} = article} <- Blog.publish_article(author, article_params) do
      conn
      |> put_status(:created)
      |> render(:show, article: article)
    end
  end

  def show(conn, %{"slug" => slug}) do
    article = Blog.article_by_slug!(slug)
    render(conn, :show, article: article)
  end
end
