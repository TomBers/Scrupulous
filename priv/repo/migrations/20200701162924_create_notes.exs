defmodule Scrupulous.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :start_line, :integer
      add :end_line, :integer
      add :note, :text
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:notes, [:book_id])
  end
end
