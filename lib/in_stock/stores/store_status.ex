defmodule InStock.Stores.StoreStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "store_statuses" do
    field :available, :boolean, default: false
    field :price, :string

    belongs_to :store, InStock.Stores.Store

    timestamps()
  end

  @doc false
  def changeset(store_status, attrs) do
    store_status
    |> cast(attrs, [:available, :price, :store_id])
    |> validate_required([:available, :store_id])
    |> unique_constraint([:store_id])
  end
end
