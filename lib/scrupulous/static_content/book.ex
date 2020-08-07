defmodule Scrupulous.StaticContent.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.UserContent.Note
  alias Scrupulous.StaticContent.Resource


  schema "books" do
    field :author, :string
    field :country, :string
    field :file_name, :string
    field :publication_year, :integer
    field :title, :string
    field :slug, :string
    field :type, :string

    has_many :notes, Note, on_delete: :delete_all
    has_many :resources, Resource, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :country, :publication_year, :file_name, :slug])
    |> validate_required([:title, :author, :country, :publication_year, :file_name, :slug])
  end
end
