defmodule InStock.Checker.CheckerSupervisor do
  use DynamicSupervisor

  alias InStock.{
    Checker,
    Stores
  }

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def spawn_checkers() do
    for store <- Stores.list_stores() do
      {:ok, _pid} = start_checker(store.id)
    end
  end

  def start_checker(store_id) do
    child_spec = {Checker, store_id}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
