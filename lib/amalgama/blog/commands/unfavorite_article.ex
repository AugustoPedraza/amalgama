defmodule Amalgama.Blog.Commands.UnfavoriteArticle do
  defstruct article_uuid: "",
            unfavorited_by_author_uuid: ""

  use ExConstructor
  use Vex.Struct

  validates(:article_uuid, uuid: true)
  validates(:unfavorited_by_author_uuid, uuid: true)

  alias __MODULE__
  alias Amalgama.Blog.Projections.{Article, Author}

  @doc """
  Assign the article
  """
  def assign_article(%UnfavoriteArticle{} = cmd, %Article{uuid: uuid}) do
    %UnfavoriteArticle{cmd | article_uuid: uuid}
  end

  @doc """
  Assign the author who is favoriting the article
  """
  def assign_unfavoriting_author(%UnfavoriteArticle{} = cmd, %Author{uuid: uuid}) do
    %UnfavoriteArticle{cmd | unfavorited_by_author_uuid: uuid}
  end
end
