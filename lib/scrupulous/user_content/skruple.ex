defmodule Scrupulous.UserContent.Skruple do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skruples" do
    field :note_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(skruple, attrs) do
    skruple
    |> cast(attrs, [:note_id, :user_id])
    |> validate_required([])
  end
end
