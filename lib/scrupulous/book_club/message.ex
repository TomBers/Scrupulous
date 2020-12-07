defmodule Scrupulous.BookClub.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrupulous.Accounts.User
  alias Scrupulous.BookClub.Room

  schema "messages" do
    field :content, :binary
    field :parent, :string

    belongs_to :room, Room
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:parent, :content])
    |> validate_required([:content])
  end
end
