defmodule InStock.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    field :price_selector, :string
    field :stock_matcher, :string
    field :stock_selector, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :url, :stock_selector, :stock_matcher, :price_selector])
    |> validate_required([:name, :url, :stock_selector, :stock_matcher, :price_selector])
  end
end
