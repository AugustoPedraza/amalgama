defmodule AmalgamaWeb.JWT do
  @moduledoc """
  JSON Web Token helper functions, using Guardian
  """

  def generate_jwt(resource, type \\ [type: :token]) do
    case Amalgama.Auth.Guardian.encode_and_sign(resource, %{}, type) do
      {:ok, jwt, _full_claims} -> {:ok, jwt}
    end
  end
end
