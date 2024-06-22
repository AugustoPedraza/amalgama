defmodule AmalgamaWeb.ArticleController do
  use AmalgamaWeb, :controller

  alias Amalgama.Blog
  alias Blog.Projections.Article

  action_fallback AmalgamaWeb.FallbackController

  def index(conn, params) do
    {articles, total_count} = Blog.list_articles(params)
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

  # def update(conn, %{"id" => id, "article" => article_params}) do
  #   article = Blog.get_article!(id)

  #   with {:ok, %Article{} = article} <- Blog.update_article(article, article_params) do
  #     render(conn, :show, article: article)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   article = Blog.get_article!(id)

  #   with {:ok, %Article{}} <- Blog.delete_article(article) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
