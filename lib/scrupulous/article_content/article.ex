defmodule Scrupulous.ArticleContent.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :content, :binary
    field :slug, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :content, :slug, :user_id])
    |> validate_required([:title, :content, :slug, :user_id])
  end
end
