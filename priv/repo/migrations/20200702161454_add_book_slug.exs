defmodule Scrupulous.Repo.Migrations.AddBookSlug do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :slug, :string
    end

    create unique_index(:books, [:slug])

  end
end
