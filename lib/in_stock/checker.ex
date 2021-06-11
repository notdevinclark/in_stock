defmodule InStock.Checker do
  use GenServer
  require Logger
  alias InStock.Checker.StoreChecker

  def start_link(store_id) do
    GenServer.start_link(__MODULE__, store_id)
  end

  # Server Call Backs

  def init(store_id) do
    {:ok, %{store_id: store_id, timer: nil}, {:continue, :initial_timer}}
  end

  def handle_continue(:initial_timer, state) do
    timer = Process.send_after(self(), :tick, 5000)
    {:noreply, %{state | timer: timer}}
  end

  def handle_info(:tick, %{timer: timer, store_id: store_id} = state) do
    check_store(store_id)
    Process.cancel_timer(timer)
    timer = Process.send_after(self(), :tick, 5000)
    {:noreply, %{state | timer: timer}}
  end

  defp check_store(store_id) do
    case StoreChecker.check(store_id) do
      {:error, name, message} -> Logger.info(store: name, error: message)
      {name, status, price} -> Logger.info(store: name, status: status, price: price)
    end
  end
end
