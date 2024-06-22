defmodule AmalgamaWeb.SessionController do
  use AmalgamaWeb, :controller

  alias Amalgama.Auth

  alias Amalgama.Accounts.Projections.User

  action_fallback AmalgamaWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- Auth.authenticate(email, password),
         {:ok, jwt} <- generate_jwt(user) do
      conn
      |> put_status(:created)
      |> put_view(AmalgamaWeb.UserJSON)
      |> render(:show, user: user, jwt: jwt)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AmalgamaWeb.ValidationJSON)
        |> render("validation.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end
