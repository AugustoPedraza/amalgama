defmodule AmalgamaWeb.UserAuth do
  use Guardian.Plug.Pipeline,
    otp_app: :amalgama,
    error_handler: __MODULE__,
    key: :current_user,
    module: Amalgama.Auth.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, scheme: "Token"
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureAuthenticated

  @doc """
  Handles authentication errors by returning appropriate HTTP status codes and JSON responses.
  """
  def auth_error(conn, {type, _reason}, _opts) do
    status =
      case type do
        :unauthenticated -> :unauthorized
        :unauthorized -> :forbidden
        :no_resource_found -> :unauthorized
        _ -> :internal_server_error
      end

    respond_with(conn, status, type)
  end

  defp respond_with(conn, status, type) do
    body = Jason.encode!(%{error: %{type: to_string(type)}})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
