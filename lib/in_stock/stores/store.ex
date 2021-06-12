defmodule InStock.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    field :price_selector, :string
    field :stock_matcher, :string
    field :stock_selector, :string
    field :url, :string

    has_one :store_status, InStock.Stores.StoreStatus

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :url, :stock_selector, :stock_matcher, :price_selector])
    |> validate_required([:name, :url, :stock_selector, :stock_matcher, :price_selector])
    |> validate_regex(:stock_matcher)
  end

  defp validate_regex(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn current_field, value ->
      case Regex.compile(value) do
        {:ok, _} -> []
        {:error, {message, _}} -> [{current_field, "Bad Regex: #{message}"}]
      end
    end)
  end
end
