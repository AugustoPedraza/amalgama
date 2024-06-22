defmodule Amalgama.Blog.ArticleTest do
  use Amalgama.AggregateCase, aggregate: Amalgama.Blog.Aggregates.Article

  alias Amalgama.Blog.Events.ArticlePublished

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:publish_article_cmd, article_uuid: article_uuid, author_uuid: author_uuid),
        [
          %ArticlePublished{
            article_uuid: article_uuid,
            slug: "how-to-train-your-dragon",
            title: "How to train your dragon",
            description: "Ever wonder how?",
            body: "You have to believe",
            tag_list: ["dragons", "training"],
            author_uuid: author_uuid
          }
        ]
      )
    end
  end
end
