defmodule App.Updater do
  use GenServer

  @key Application.get_env(:app, :riot_api_key)

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:find, name}, status) do
    find_player(name)

    {:noreply, status}
  end

  def find_player({:name, name}) do
    "v1.4/summoner/by-name"
      |> from_url(name)
      |> HTTPotion.get
      |> handle_response
  end

  def find_player({:summoner_id, id}) do
    "v1.4/summoner"
      |> from_url(id)
      |> HTTPotion.get
      |> handle_response
  end

  defp create_players([head | tail]) do
    data = elem(head, 1)

    App.Repo.insert %App.Player{summoner_id: data["id"]}

    create_players(tail)
  end

  defp from_url(endpoint, arg) do
    "https://na.api.pvp.net/api/lol/na/#{endpoint}/#{arg},test,test2,test3?api_key=#{@key}"
  end

  defp handle_response(%HTTPotion.Response{body: body, status_code: 200}) do
    body |> parse_json |> create_players
  end

  defp handle_response(%HTTPotion.Response{status_code: 404}) do
    IO.puts "not found"
  end

  defp handle_response(%HTTPotion.Response{status_code: 429}) do
    IO.puts "limited"
  end

  defp parse_json(raw) do
    Poison.Parser.parse!(raw)
  end
end
