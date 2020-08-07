defmodule Scrupulous.Repo.Migrations.AddBookType do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :type, :string
    end
  end
end
