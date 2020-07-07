defmodule Scrupulous.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :label, :string
      add :link, :text
      add :category, :string
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:resources, [:book_id])
  end
end
