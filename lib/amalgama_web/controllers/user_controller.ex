defmodule AmalgamaWeb.UserController do
  use AmalgamaWeb, :controller

  alias Amalgama.Accounts
  alias Amalgama.Auth.Guardian

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
    user = conn.private.guardian_current_user_resource
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render(:show, user: user, jwt: jwt)
  end
end
