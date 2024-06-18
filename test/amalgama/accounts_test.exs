defmodule Amalgama.AccountsTest do
  use Amalgama.DataCase

  import Amalgama.Factory

  alias Amalgama.Accounts
  alias Amalgama.Accounts.Projections.User

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:api_user))

      assert user.bio == nil
      assert user.email == "jake@jake.jake"
      assert user.hashed_password == "jakejake"
      assert user.image == nil
      assert user.username == "jake"
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:api_user, username: ""))

      assert errors == %{username: ["can't be empty"]}
    end
  end
end
