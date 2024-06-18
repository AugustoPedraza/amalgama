defmodule Amalgama.Accounts.Queries.UserByUsername do
  import Ecto.Query

  alias Amalgama.Accounts.Projections.User

  def new(username) do
    from u in User,
      where: u.username == ^username
  end
end
