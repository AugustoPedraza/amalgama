defmodule AmalgamaWeb.Plugs.LoadArticleBySlug do
  use Phoenix.Controller, namespace: AmalgamaWeb

  import Plug.Conn

  alias Amalgama.Blog

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"slug" => slug}} = conn, _opts) do
    article = Blog.article_by_slug!(slug)

    assign(conn, :article, article)
  end

  def call(conn, _) do
    conn
  end
end
