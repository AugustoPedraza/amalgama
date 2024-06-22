defmodule AmalgamaWeb.UserJSON do
  alias Amalgama.Accounts.Projections.User

  # @doc """
  # Renders a list of users.
  # """
  # def index(%{users: users}) do
  #   %{data: for(user <- users, do: data(user))}
  # end

  @doc """
  Renders a single user.
  """
  def show(%{user: user, jwt: jwt}) do
    %{data: %{user: data(user, jwt), jwt: jwt}}
  end

  defp data(%User{} = user, jwt) do
    %{
      username: user.username,
      email: user.email,
      token: jwt,
      hashed_password: user.hashed_password,
      bio: user.bio,
      image: user.image
    }
  end
end
