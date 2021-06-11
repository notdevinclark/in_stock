defmodule InStock.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string
      add :url, :string
      add :stock_selector, :string
      add :stock_matcher, :string
      add :price_selector, :string

      timestamps()
    end

  end
end
