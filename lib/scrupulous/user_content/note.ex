defmodule Scrupulous.UserContent.Note do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.StaticContent.Book

  schema "notes" do
    field :end_line, :integer
    field :note, :string
    field :start_line, :integer
    belongs_to :book, Book

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:start_line, :end_line, :note, :book_id])
    |> validate_required([:start_line, :end_line, :note])
  end
end
