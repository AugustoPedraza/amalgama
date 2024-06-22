defmodule Amalgama.Blog.Supervisor do
  use Supervisor

  alias Amalgama.Blog

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Blog.Workflows.CreateAuthorFromUser,
        Blog.Projectors.Article
      ],
      strategy: :one_for_one
    )
  end
end
