defmodule Amalgama.BlogTest do
  use Amalgama.DataCase

  alias Amalgama.Blog

  describe "articles" do
    alias Amalgama.Blog.Article

    import Amalgama.BlogFixtures

    @invalid_attrs %{description: nil, title: nil, body: nil, slug: nil, tag_list: nil, favorite_count: nil, published_at: nil, author_uuid: nil, author_username: nil, author_bio: nil, author_image: nil}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Blog.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Blog.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{description: "some description", title: "some title", body: "some body", slug: "some slug", tag_list: [], favorite_count: 42, published_at: ~N[2024-06-21 08:33:00], author_uuid: "some author_uuid", author_username: "some author_username", author_bio: "some author_bio", author_image: "some author_image"}

      assert {:ok, %Article{} = article} = Blog.create_article(valid_attrs)
      assert article.description == "some description"
      assert article.title == "some title"
      assert article.body == "some body"
      assert article.slug == "some slug"
      assert article.tag_list == []
      assert article.favorite_count == 42
      assert article.published_at == ~N[2024-06-21 08:33:00]
      assert article.author_uuid == "some author_uuid"
      assert article.author_username == "some author_username"
      assert article.author_bio == "some author_bio"
      assert article.author_image == "some author_image"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", body: "some updated body", slug: "some updated slug", tag_list: [], favorite_count: 43, published_at: ~N[2024-06-22 08:33:00], author_uuid: "some updated author_uuid", author_username: "some updated author_username", author_bio: "some updated author_bio", author_image: "some updated author_image"}

      assert {:ok, %Article{} = article} = Blog.update_article(article, update_attrs)
      assert article.description == "some updated description"
      assert article.title == "some updated title"
      assert article.body == "some updated body"
      assert article.slug == "some updated slug"
      assert article.tag_list == []
      assert article.favorite_count == 43
      assert article.published_at == ~N[2024-06-22 08:33:00]
      assert article.author_uuid == "some updated author_uuid"
      assert article.author_username == "some updated author_username"
      assert article.author_bio == "some updated author_bio"
      assert article.author_image == "some updated author_image"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_article(article, @invalid_attrs)
      assert article == Blog.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Blog.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Blog.change_article(article)
    end
  end
end
