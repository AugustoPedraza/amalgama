defmodule Amalgama.AccountsTest do
  use Amalgama.DataCase

  import Amalgama.Factory

  alias Amalgama.Accounts
  alias Amalgama.Auth
  alias Amalgama.Accounts.Projections.User

  defp register_user(attrs \\ %{}) do
    Accounts.register_user(build(:api_user, attrs))
  end

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %User{} = user} = register_user()

      assert user.bio == nil
      assert user.email == "jake@jake.jake"
      refute user.hashed_password == nil
      assert user.image == nil
      assert user.username == "jake"
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} = register_user(username: "")

      assert errors == %{username: ["can't be empty"]}
    end

    @tag :integration
    test "should fail when username already taken and return error" do
      assert {:ok, %User{}} = register_user()
      assert {:error, :validation_failure, errors} = register_user(email: "another@email.com")

      assert errors == %{username: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> register_user() end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      assert {:error, :validation_failure, errors} = register_user(username: "j@ke")

      assert errors == %{username: ["is invalid"]}
    end

    @tag :integration
    test "should convert username to lowercase" do
      assert {:ok, %User{} = user} = register_user(username: "JAKE")

      assert user.username == "jake"
    end

    @tag :integration
    test "should fail when email address already taken and return error" do
      assert {:ok, %User{}} = register_user(username: "jake")
      assert {:error, :validation_failure, errors} = register_user(username: "jake2")

      assert errors == %{email: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical email addresses at same time and return error" do
      1..2
      |> Enum.map(fn x -> Task.async(fn -> register_user(username: "user#{x}") end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when email address format is invalid and return error" do
      assert {:error, :validation_failure, errors} = register_user(email: "invalidemail")

      assert errors == %{email: ["is invalid"]}
    end

    @tag :integration
    test "should convert email address to lowercase" do
      assert {:ok, %User{} = user} = register_user(email: "JAKE@JAKE.JAKE")

      assert user.email == "jake@jake.jake"
    end

    @tag :integration
    test "should hash password" do
      assert {:ok, %User{} = user} = register_user()

      assert Auth.validate_password("jakejake", user.hashed_password)
    end
  end
end
