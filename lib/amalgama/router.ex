defmodule Amalgama.Router do
  use Commanded.Commands.Router

  alias Amalgama.Accounts.Aggregates.User
  alias Amalgama.Accounts.Commands.RegisterUser

  alias Amalgama.Blog.Aggregates.Author
  alias Amalgama.Blog.Commands.CreateAuthor

  alias Amalgama.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  identify(Author, by: :author_uuid, prefix: "author-")
  identify(User, by: :user_uuid, prefix: "user-")

  dispatch([RegisterUser], to: User)
  dispatch([CreateAuthor], to: Author)
end
