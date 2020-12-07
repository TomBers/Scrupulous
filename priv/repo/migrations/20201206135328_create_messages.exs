defmodule Scrupulous.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :parent, :string
      add :content, :binary
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:room, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:room_id])
  end
end
