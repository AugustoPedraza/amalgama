defmodule Amalgama.Router do
  use Commanded.Commands.Router

  alias Amalgama.Accounts.Aggregates.User
  alias Amalgama.Accounts.Commands.RegisterUser

  alias Amalgama.Blog.Aggregates.{Author, Article}
  alias Amalgama.Blog.Commands.{CreateAuthor, PublishArticle, FavoriteArticle, UnfavoriteArticle}

  alias Amalgama.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  identify(Author, by: :author_uuid, prefix: "author-")
  identify(User, by: :user_uuid, prefix: "user-")
  identify(Article, by: :article_uuid, prefix: "article-")

  dispatch([RegisterUser], to: User)
  dispatch([CreateAuthor], to: Author)
  dispatch([PublishArticle, FavoriteArticle, UnfavoriteArticle], to: Article)
end
