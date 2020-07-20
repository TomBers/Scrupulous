defmodule Scrupulous.UserContent.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.StaticContent.Book

  schema "bookmarks" do
    field :page, :integer
    field :user_id, :id

    belongs_to :book, Book

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:page, :user_id, :book_id])
    |> validate_required([:page, :user_id, :book_id])
  end
end
