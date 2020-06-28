defmodule Scrupulous.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :country, :string
      add :publication_year, :integer
      add :file_name, :string

      timestamps()
    end

  end
end
