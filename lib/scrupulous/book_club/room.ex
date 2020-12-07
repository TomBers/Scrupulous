defmodule Scrupulous.BookClub.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scrupulous.BookClub.Message

  schema "room" do
    field :name, :string
    field :subtitle, :string

    has_many :messages, Message, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :subtitle])
    |> validate_required([:name, :subtitle])
  end
end
