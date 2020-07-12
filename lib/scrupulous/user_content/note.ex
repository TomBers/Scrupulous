defmodule Scrupulous.UserContent.Note do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.StaticContent.Book
  alias Scrupulous.Accounts.User
  alias Scrupulous.UserContent.Skruple

  schema "notes" do
    field :end_line, :integer
    field :note, :string
    field :start_line, :integer
    belongs_to :book, Book
    belongs_to :user, User

    has_many :skruples, Skruple, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:start_line, :end_line, :note, :book_id, :user_id])
    |> validate_required([:start_line, :end_line, :note])
  end
end
