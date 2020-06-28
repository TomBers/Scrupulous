defmodule Scrupulous.StaticContent.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :country, :string
    field :file_name, :string
    field :publication_year, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :country, :publication_year, :file_name])
    |> validate_required([:title, :author, :country, :publication_year, :file_name])
  end
end
