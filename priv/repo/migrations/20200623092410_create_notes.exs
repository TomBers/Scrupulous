defmodule Scrupulous.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :book, :string
      add :start_line, :integer
      add :end_line, :integer
      add :note, :text

      timestamps()
    end

  end
end
