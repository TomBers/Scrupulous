defmodule Scrupulous.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:room) do
      add :name, :string
      add :subtitle, :string

      timestamps()
    end

  end
end
