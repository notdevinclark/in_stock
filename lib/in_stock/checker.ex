defmodule InStock.Checker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  # Server Call Backs

  def init(:ok) do
    {:ok, %{}, {:continue, :initial_timer}}
  end

  def handle_continue(:initial_timer, _state) do
    timer = Process.send_after(self(), :tick, 5000)
    {:noreply, %{timer: timer}}
  end

  def handle_info(:tick, %{timer: timer}) do
    Logger.info("Tick was called")
    Process.cancel_timer(timer)
    timer = Process.send_after(self(), :tick, 5000)
    {:noreply, %{timer: timer}}
  end
end
