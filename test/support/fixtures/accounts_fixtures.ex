defmodule Amalgama.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Amalgama.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        email: "some email",
        hashed_password: "some hashed_password",
        image: "some image",
        username: "some username"
      })
      |> Amalgama.Accounts.register_user()

    user
  end
end
