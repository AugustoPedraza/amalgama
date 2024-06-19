defmodule Amalgama.Accounts.Queries.UserByEmail do
  import Ecto.Query

  alias Amalgama.Accounts.Projections.User

  def new(email) do
    from u in User,
      where: u.email == ^email
  end
end
