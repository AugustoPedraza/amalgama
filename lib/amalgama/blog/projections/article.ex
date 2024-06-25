defmodule Amalgama.Blog.Projections.Article do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "blog_articles" do
    field :description, :string
    field :title, :string
    field :body, :string
    field :slug, :string
    field :tag_list, {:array, :string}
    field :favorite_count, :integer
    field :published_at, :utc_datetime

    field :author_uuid, :binary_id
    field :author_username, :string
    field :author_bio, :string
    field :author_image, :string

    field :favorited, :boolean, virtual: true, default: false

    timestamps(type: :utc_datetime)
  end
end
