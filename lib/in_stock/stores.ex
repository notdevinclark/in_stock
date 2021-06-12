defmodule InStock.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias InStock.Repo

  alias InStock.Stores.Store
  alias InStock.Stores.StoreStatus

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    Repo.all(Store)
    |> Repo.preload(:store_status)
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id), do: Repo.get!(Store, id) |> Repo.preload(:store_status)

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    result =
      %Store{}
      |> Store.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, store} ->
        %StoreStatus{}
        |> StoreStatus.changeset(%{store_id: store.id})
        |> Repo.insert()

      {:error, _change_set} ->
        :noop
    end

    result
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{data: %Store{}}

  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end

  ### StoreStatus Functions

  @doc """
  Updates a store_status.

  ## Examples

      iex> update_store_status(store_status, %{field: new_value})
      {:ok, %StoreStatus{}}

      iex> update_store_status(store_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store_status(%StoreStatus{} = store_status, attrs) do
    store_status
    |> StoreStatus.changeset(attrs)
    |> Repo.update()
  end
end
