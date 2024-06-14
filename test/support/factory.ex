defmodule Amalgama.Factory do
  use ExMachina

  alias Amalgama.Accounts.Commands.RegisterUser

  def api_user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def register_user_cmd_factory do
    struct(RegisterUser, build(:api_user))
  end
end
