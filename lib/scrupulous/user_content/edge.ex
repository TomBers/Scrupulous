defmodule Scrupulous.UserContent.Edge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "edges" do
    field :label, :string

    belongs_to :source, Book
    belongs_to :target, Book

    timestamps()
  end

  @doc false
  def changeset(edge, attrs) do
    edge
    |> cast(attrs, [:label, :source_id, :target_id])
    |> validate_required([:label, :source_id, :target_id])
  end
end
