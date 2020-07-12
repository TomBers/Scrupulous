defmodule Scrupulous.UserContent.Skruple do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skruples" do
    field :note_id, :id

    belongs_to :user, Scrupulous.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(skruple, attrs) do
    skruple
    |> cast(attrs, [:note_id, :user_id])
    |> validate_required([])
  end
end
