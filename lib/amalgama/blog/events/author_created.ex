defmodule Amalgama.Blog.Events.AuthorCreated do
  @derive [Jason.Encoder]
  defstruct [
    :author_uuid,
    :user_uuid,
    :username
  ]
end
