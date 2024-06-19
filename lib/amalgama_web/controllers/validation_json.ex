defmodule AmalgamaWeb.ValidationJSON do
  @doc """
  Renders a single user.
  """
  def render("validation.json", %{errors: errors}) do
    %{errors: errors}
  end
end
