defmodule AmalgamaWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AmalgamaWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AmalgamaWeb.ValidationJSON)
    |> render("validation.json", errors: errors)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: AmalgamaWeb.ErrorHTML, json: AmalgamaWeb.ErrorJSON)
    |> render(:"404")
  end
end
