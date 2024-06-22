defmodule AmalgamaWeb.ArticleControllerTest do
  use AmalgamaWeb.ConnCase

  import Amalgama.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
    test "should create and return article when data is valid", %{conn: conn} do
      conn = post authenticated_conn(conn), ~p"/api/articles", article: build(:article)
      json = json_response(conn, 201)["data"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => "how-to-train-your-dragon",
               "title" => "How to train your dragon",
               "description" => "Ever wonder how?",
               "body" => "You have to believe",
               "tagList" => ["dragons", "training"],
               "createdAt" => created_at,
               "updatedAt" => updated_at,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => "jake",
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }

      refute created_at == ""
      refute updated_at == ""
    end
  end
end
