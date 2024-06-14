defmodule AmalgamaWeb.UserControllerTest do
  use AmalgamaWeb.ConnCase

  import Amalgama.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :api
    test "create and return user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: build(:api_user))
      assert data = json_response(conn, 201)["data"]

      assert %{
        "bio" => nil,
        "email" => "jake@jake.jake",
        "image" => nil,
        "username" => "jake",
      } = data["user"]
    end
  end
end
