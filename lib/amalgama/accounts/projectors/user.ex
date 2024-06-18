defmodule Amalgama.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: Amalgama.CommandedApp,
    repo: Amalgama.Repo,
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias Amalgama.Accounts.Events.UserRegistered
  alias Amalgama.Accounts.Projections.User

  project(%UserRegistered{} = registered, _medatada, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end)
end
