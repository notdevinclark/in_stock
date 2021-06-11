defmodule InStock.Checker do
  use GenServer
  alias InStock.Checker.StoreChecker
  require Logger

  @time :timer.minutes(5)

  # Public API

  def start_link(store_id) do
    GenServer.start_link(__MODULE__, store_id)
  end

  # Server Call Backs

  def init(store_id) do
    {:ok, %{store_id: store_id, timer: nil}, {:continue, :initial_timer}}
  end

  def handle_continue(:initial_timer, state) do
    check_and_schedule(@time, state)
  end

  def handle_info(:tick, state) do
    check_and_schedule(@time, state)
  end

  # Utility

  defp check_and_schedule(milliseconds, %{store_id: store_id} = state) do
    check_store(store_id)
    {:noreply, %{state | timer: Process.send_after(self(), :tick, milliseconds)}}
  end

  defp check_store(store_id) do
    case StoreChecker.check(store_id) do
      {:error, name, message} -> Logger.info(store: name, error: message)
      {name, status, price} -> Logger.info(store: name, status: status, price: price)
    end
  end
end
