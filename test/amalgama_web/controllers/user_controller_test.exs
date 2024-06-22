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

  describe "get current user" do
    @tag :web
    test "should return user when authenticated", %{conn: conn} do
      response =
        conn
        |> authenticated_conn()
        |> get(~p"/api/user")
        |> json_response(200)

      assert %{
               "bio" => nil,
               "email" => "jake@jake.jake",
               "token" => token,
               "image" => nil,
               "username" => "jake"
             } = response["data"]["user"]

      refute token == ""
      refute token == nil
    end

    @tag :web
    test "should not return user when unauthenticated", %{conn: conn} do
      conn = get(conn, ~p"/api/user")

      assert response(conn, 401)
    end
  end

  defp authenticated_conn(conn) do
    {:ok, user} = fixture(:user)
    {:ok, jwt} = AmalgamaWeb.JWT.generate_jwt(user)

    put_req_header(conn, "authorization", "Token " <> jwt)
  end
end
