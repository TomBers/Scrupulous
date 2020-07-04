defmodule Scrupulous.Repo.Migrations.CreateEdges do
  use Ecto.Migration

  def change do
    create table(:edges) do
      add :label, :string
      add :source_id, references(:books, on_delete: :nothing)
      add :target_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:edges, [:source_id])
    create index(:edges, [:target_id])
  end
end
