defmodule Scrupulous.ArticleContent.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scrupulous.ArticleContent.Note

  schema "articles" do
    field :content, :binary
    field :slug, :string
    field :title, :string
    field :user_id, :id

    has_many :notes, Note, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :content, :slug, :user_id])
    |> validate_required([:title, :content, :slug, :user_id])
  end
end
