defmodule Amalgama.AccountsTest do
  use Amalgama.DataCase, async: false

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

    @tag :integration
    test "should fail when username already taken and return error" do
      assert {:ok, %User{}} = Accounts.register_user(build(:api_user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:api_user))

      assert errors == %{username: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:api_user)) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:api_user, username: "j@ke"))

      assert errors == %{username: ["is invalid"]}
    end

    @tag :integration
    test "should convert username to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:api_user, username: "JAKE"))

      assert user.username == "jake"
    end
  end
end
