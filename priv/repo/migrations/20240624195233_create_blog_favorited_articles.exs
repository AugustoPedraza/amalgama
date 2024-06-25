defmodule Amalgama.Repo.Migrations.CreateBlogFavoritedArticles do
  use Ecto.Migration

  def change do
    create table(:blog_favorited_articles, primary_key: false) do
      add :article_uuid, :uuid, primary_key: true
      add :favorited_by_author_uuid, :uuid, primary_key: true

      timestamps(type: :utc_datetime)
    end
  end
end
