defmodule App.BusyBeaver do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add(name: name) do
    GenServer.cast(__MODULE__, {:add, {:name, name}})
  end

  def add(summoner_id: summoner_id) do
    GenServer.cast(__MODULE__, {:add, {:summoner_id, summoner_id}})
  end

  def handle_cast({:add, name}, status) do
    :poolboy.transaction(:updater_pool, fn (worker) -> find_player(worker, name) end)

    {:noreply, status}
  end

  defp find_player(worker, name) do
    GenServer.cast(worker, {:find, name})
  end
end
