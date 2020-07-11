defmodule Scrupulous.Repo.Migrations.CreateSkruples do
  use Ecto.Migration

  def change do
    create table(:skruples) do
      add :note_id, references(:notes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:skruples, [:note_id])
    create index(:skruples, [:user_id])
  end
end
