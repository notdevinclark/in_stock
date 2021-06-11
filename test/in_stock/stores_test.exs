defmodule InStock.StoresTest do
  use InStock.DataCase

  alias InStock.Stores

  describe "stores" do
    alias InStock.Stores.Store

    @valid_attrs %{name: "some name", price_selector: "some price_selector", stock_matcher: "some stock_matcher", stock_selector: "some stock_selector", url: "some url"}
    @update_attrs %{name: "some updated name", price_selector: "some updated price_selector", stock_matcher: "some updated stock_matcher", stock_selector: "some updated stock_selector", url: "some updated url"}
    @invalid_attrs %{name: nil, price_selector: nil, stock_matcher: nil, stock_selector: nil, url: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stores.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Stores.list_stores() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Stores.get_store!(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Stores.create_store(@valid_attrs)
      assert store.name == "some name"
      assert store.price_selector == "some price_selector"
      assert store.stock_matcher == "some stock_matcher"
      assert store.stock_selector == "some stock_selector"
      assert store.url == "some url"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, %Store{} = store} = Stores.update_store(store, @update_attrs)
      assert store.name == "some updated name"
      assert store.price_selector == "some updated price_selector"
      assert store.stock_matcher == "some updated stock_matcher"
      assert store.stock_selector == "some updated stock_selector"
      assert store.url == "some updated url"
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Stores.update_store(store, @invalid_attrs)
      assert store == Stores.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Stores.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Stores.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Stores.change_store(store)
    end
  end
end
