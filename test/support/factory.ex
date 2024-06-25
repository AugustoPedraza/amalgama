defmodule Amalgama.Factory do
  use ExMachina

  alias Amalgama.Accounts.Commands.RegisterUser

  alias Amalgama.Blog.Commands.PublishArticle
  alias Amalgama.Blog.Events.ArticlePublished

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      password: "jakejake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def article_factory do
    %{
      article_uuid: UUID.uuid4(),
      author_uuid: UUID.uuid4(),
      slug: "how-to-train-your-dragon",
      title: "How to train your dragon",
      description: "Ever wonder how?",
      body: "You have to believe",
      tag_list: ["dragons", "training"]
    }
  end

  def author_factory do
    %{
      user_uuid: UUID.uuid4(),
      username: "jake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def publish_article_cmd_factory do
    struct(PublishArticle, build(:article))
  end

  def register_user_cmd_factory do
    struct(RegisterUser, build(:user))
  end

  def article_published_evt_factory do
    struct(ArticlePublished, build(:article))
  end
end
