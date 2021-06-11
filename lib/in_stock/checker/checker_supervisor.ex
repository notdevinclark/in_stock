defmodule InStock.Checker.CheckerSupervisor do
  use DynamicSupervisor

  alias InStock.{
    Stores,
    Checker
  }

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, state} = DynamicSupervisor.init(strategy: :one_for_one)

    Task.async(fn -> spawn_checkers() end)

    {:ok, state}
  end

  def start_checker(store_id) do
    child_spec = {Checker, store_id}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def spawn_checkers() do
    for store <- Stores.list_stores() do
      start_checker(store.id)
    end
  end

  def handle_info({:DOWN, _, _, _, _}, state), do: {:noreply, state}
end
