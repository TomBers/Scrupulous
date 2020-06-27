defmodule Scrupulous.UserContent.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :book, :string
    field :end_line, :integer
    field :note, :string
    field :start_line, :integer

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:book, :start_line, :end_line, :note])
    |> validate_required([:book, :start_line, :end_line, :note])
  end
end
