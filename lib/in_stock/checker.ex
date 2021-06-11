defmodule InStock.Checker do
  use GenServer
  require Logger

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
    Logger.info("Tick was called for #{store_id}")
    Process.cancel_timer(timer)
    timer = Process.send_after(self(), :tick, 5000)
    {:noreply, %{state | timer: timer}}
  end
end
