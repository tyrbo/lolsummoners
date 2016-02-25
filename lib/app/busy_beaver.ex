defmodule App.BusyBeaver do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add(name: name) do
    name = clean(name)

    GenServer.cast(__MODULE__, {:add, {:name, name}})
  end

  def add(summoner_id: summoner_id) do
    GenServer.cast(__MODULE__, {:add, {:summoner_id, summoner_id}})
  end

  def get_league([head|tail]) do
    Enum.split([head|tail], 10)
      |> Tuple.to_list
      |> get_leagues
  end

  def get_league(summoner_id) do
    get_league([summoner_id])
  end

  def get_leagues([head | tail]) do
    summoner_ids = Enum.join(head, ",")

    GenServer.cast(__MODULE__, {:get_league, summoner_ids})

    get_leagues(tail)
  end

  def get_leagues([]), do: nil

  def handle_cast({:add, name}, status) do
    :poolboy.transaction(:updater_pool, fn (worker) -> find_player(worker, name) end)

    {:noreply, status}
  end

  def handle_cast({:get_league, summoner_id}, status) do
    :poolboy.transaction(:updater_pool, fn (worker) -> GenServer.cast(worker, {:get_league, summoner_id}) end)

    {:noreply, status}
  end

  defp clean(name) do
    name
      |> String.downcase
      |> String.replace(" ", "")
  end

  defp find_player(worker, name) do
    GenServer.cast(worker, {:find, name})
  end
end
