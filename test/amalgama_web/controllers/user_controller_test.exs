defmodule AmalgamaWeb.UserControllerTest do
  use AmalgamaWeb.ConnCase

  import Amalgama.Factory

  def fixture(:user, attrs \\ []) do
    build(:api_user, attrs) |> Amalgama.Accounts.register_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "create and return user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: build(:api_user))
      assert data = json_response(conn, 201)["data"]

      assert %{
               "bio" => nil,
               "email" => "jake@jake.jake",
               "image" => nil,
               "username" => "jake"
             } = data["user"]
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: build(:api_user, username: ""))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "should not create user and render errors when username has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)

      # attempt to register the same username
      conn = post(conn, ~p"/api/users", user: build(:api_user, email: "jake2@jake.jake"))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end
end
