defmodule Amalgama.Blog.Commands.FavoriteArticle do
  defstruct article_uuid: "",
            favorited_by_author_uuid: ""

  use ExConstructor
  use Vex.Struct

  validates(:article_uuid, uuid: true)
  validates(:favorited_by_author_uuid, uuid: true)

  alias __MODULE__
  alias Amalgama.Blog.Projections.{Article, Author}

  @doc """
  Assign the article
  """
  def assign_article(%FavoriteArticle{} = favorite_article, %Article{uuid: uuid}) do
    %FavoriteArticle{favorite_article | article_uuid: uuid}
  end

  @doc """
  Assign the author who is favoriting the article
  """
  def assign_favoriting_author(%FavoriteArticle{} = favorite_article, %Author{uuid: uuid}) do
    %FavoriteArticle{favorite_article | favorited_by_author_uuid: uuid}
  end
end
