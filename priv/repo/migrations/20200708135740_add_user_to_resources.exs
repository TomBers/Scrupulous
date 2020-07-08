defmodule Scrupulous.Repo.Migrations.AddUserToResources do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
