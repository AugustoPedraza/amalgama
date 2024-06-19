defmodule AmalgamaWeb.UserController do
  use AmalgamaWeb, :controller

  alias Amalgama.Accounts

  action_fallback AmalgamaWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end
end
