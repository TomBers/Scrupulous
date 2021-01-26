defmodule :"Elixir.Scrupulous.Repo.Migrations.Add-book-ordering-column" do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :category_letter, :string
    end
  end
end
