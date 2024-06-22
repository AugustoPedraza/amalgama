defmodule Amalgama.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Amalgama.CommandedApp,
    repo: Amalgama.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Amalgama.Blog.Events.AuthorCreated
  alias Amalgama.Blog.Projections.Author

  project(%AuthorCreated{} = author, _medatada, fn multi ->
    Ecto.Multi.insert(multi, :user, %Author{
      uuid: author.author_uuid,
      user_uuid: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil
    })
  end)
end
