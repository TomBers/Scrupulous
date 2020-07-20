defmodule Scrupulous.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :page, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:bookmarks, [:user_id])
    create index(:bookmarks, [:book_id])
  end
end
