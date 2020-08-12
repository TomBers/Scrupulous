defmodule Scrupulous.Repo.Migrations.ArticleNotesAndSkruples do
  use Ecto.Migration

  def change do
    create unique_index(:articles, [:slug])

    create table(:article_notes) do
      add :start_line, :integer
      add :end_line, :integer
      add :note, :text
      add :article_id, references(:articles, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:article_notes, [:article_id])

    create table(:article_skruples) do
      add :note_id, references(:article_notes, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:article_skruples, [:note_id])
    create index(:article_skruples, [:user_id])

  end
end
