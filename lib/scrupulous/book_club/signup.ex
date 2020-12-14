defmodule Scrupulous.BookClub.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "signups" do
    field :email, :string
    field :feature, :string

    timestamps()
  end

  @doc false
  def changeset(signup, attrs) do
    signup
    |> cast(attrs, [:email, :feature])
    |> validate_required([:email, :feature])
  end
end
