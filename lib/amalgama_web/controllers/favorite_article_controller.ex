defmodule AmalgamaWeb.FavoriteArticleController do
  use AmalgamaWeb, :controller

  alias Amalgama.Blog
  alias Blog.Projections.Article

  plug Guardian.Plug.EnsureAuthenticated when action in [:create]
  plug Guardian.Plug.LoadResource when action in [:create]

  action_fallback AmalgamaWeb.FallbackController

  def create(
        %{private: %{guardian_current_user_resource: current_user}, assigns: %{article: article}} =
          conn,
        _params
      ) do
    author = Blog.get_author!(current_user.uuid)

    with {:ok, %Article{} = article} <- Blog.favorite_article(author, article) do
      conn
      |> put_status(:created)
      |> put_view(AmalgamaWeb.ArticleJSON)
      |> render(:show, article: article)
    end
  end

  def delete(
        %{private: %{guardian_current_user_resource: current_user}, assigns: %{article: article}} =
          conn,
        _params
      ) do
    author = Blog.get_author!(current_user.uuid)

    with {:ok, %Article{} = article} <- Blog.unfavorite_article(author, article) do
      conn
      |> put_status(:created)
      |> put_view(AmalgamaWeb.ArticleJSON)
      |> render(:show, article: article)
    end
  end
end
