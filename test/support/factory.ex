defmodule Amalgama.Factory do
  use ExMachina

  alias Amalgama.Accounts.Commands.RegisterUser
  alias Amalgama.Blog.Commands.PublishArticle

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def article_factory do
    %{
      slug: "how-to-train-your-dragon",
      title: "How to train your dragon",
      description: "Ever wonder how?",
      body: "You have to believe",
      tag_list: ["dragons", "training"],
      author_uuid: UUID.uuid4()
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
end
