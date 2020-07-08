defmodule Scrupulous.Repo.Migrations.AddUserToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
