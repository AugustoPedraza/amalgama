defmodule AmalgamaWeb.SessionControllerTest do
  use AmalgamaWeb.ConnCase

  import Amalgama.Fixture

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    setup [
      :register_user
    ]

    @tag :web
    test "creates session and renders session when data is valid", %{conn: conn} do
      conn =
        post(conn, ~p"/api/users/login",
          user: %{
            email: "jake@jake.jake",
            password: "jakejake"
          }
        )

      assert data = json_response(conn, 201)["data"]

      token = data["jwt"]

      refute token == ""
      refute token == nil

      assert %{
               "bio" => nil,
               "email" => "jake@jake.jake",
               "token" => ^token,
               "image" => nil,
               "username" => "jake"
             } = data["user"]
    end

    @tag :web
    test "does not create session and renders errors when password does not match", %{conn: conn} do
      conn =
        post(conn, ~p"/api/users/login",
          user: %{
            email: "jake@jake.jake",
            password: "invalidPASS"
          }
        )

      assert json_response(conn, 422)["errors"] == %{
               "email or password" => [
                 "is invalid"
               ]
             }
    end

    @tag :web
    test "does not create session and renders errors when user not found", %{conn: conn} do
      conn =
        post(conn, ~p"/api/users/login",
          user: %{
            email: "notexist@email",
            password: "jakejake"
          }
        )

      assert json_response(conn, 422)["errors"] == %{
               "email or password" => [
                 "is invalid"
               ]
             }
    end
  end
end
