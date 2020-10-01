defmodule Scrupulous.StaticContent.Resource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.StaticContent.Book
  alias Scrupulous.Accounts.User

  schema "resources" do
    field :category, :string
    field :label, :string
    field :link, :string

    belongs_to :book, Book
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:label, :link, :category, :book_id, :user_id])
    |> validate_required([:label, :link, :category])
  end
end
