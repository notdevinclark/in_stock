defmodule InStock.Repo.Migrations.CreateStoreStatuses do
  use Ecto.Migration

  def change do
    create table(:store_statuses) do
      add :available, :boolean, default: false, null: false
      add :price, :string
      add :store_id, references(:stores, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:store_statuses, [:store_id])
  end
end
