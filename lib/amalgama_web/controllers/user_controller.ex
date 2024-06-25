defmodule AmalgamaWeb.UserController do
  use AmalgamaWeb, :controller

  alias Amalgama.Accounts

  plug Guardian.Plug.EnsureAuthenticated when action in [:current]
  plug Guardian.Plug.LoadResource when action in [:current]

  action_fallback AmalgamaWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params),
         {:ok, jwt} <- generate_jwt(user) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user, jwt: jwt)
    end
  end

  def current(conn, _params) do
    alias Amalgama.Auth.Guardian

    user = conn.private.guardian_current_user_resource
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render(:show, user: user, jwt: jwt)
  end
end
