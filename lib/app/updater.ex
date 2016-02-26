defmodule App.Updater do
  use GenServer
  require Logger

  @key Application.get_env(:riot_api, :key)

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

  def handle_cast({:get_league, summoner_id}, status) do
    get_league(summoner_id)

    {:noreply, status}
  end

  defp find_player({:name, name}) do
    "v1.4/summoner/by-name"
    |> from_url(name)
    |> fetch
    |> handle_response
    |> handle_players
  end

  defp find_player({:summoner_id, id}) do
    get_league(id)
  end

  defp fetch(url) do
    HTTPotion.get url
  end

  defp from_url(endpoint, arg) do
    "https://na.api.pvp.net/api/lol/na/#{endpoint}/#{arg}?api_key=#{@key}"
  end

  defp insert_entry(data, player_id) do
    query = """
      INSERT INTO player_rankings (player_id, division, is_fresh_blood, is_hot_streak, is_inactive, is_veteran, league_points, losses, wins, inserted_at, updated_at)
      VALUES ($1,
              $2,
              $3,
              $4,
              $5,
              $6,
              $7,
              $8,
              $9,
              now(),
              now())
      ON CONFLICT (player_id) DO UPDATE
      SET division = $2,
          is_fresh_blood = $3,
          is_hot_streak = $4,
          is_inactive = $5,
          is_veteran = $6,
          league_points = $7,
          losses = $8,
          wins = $9,
          updated_at = now()
      RETURNING *
    """

    {:ok, %{rows: [[id | _]]}} = Ecto.Adapters.SQL.query(App.Repo, query, [player_id, data["division"], data["isFreshBlood"], data["isHotStreak"], data["isInactive"], data["isVeteran"], data["leaguePoints"], data["losses"], data["wins"]])
    {:ok, id}
  end

  defp insert_league(data) do
    query = """
      INSERT INTO leagues (name, tier, inserted_at, updated_at)
      VALUES ($1,
              $2,
              now(),
              now())
      ON CONFLICT (name, tier) DO UPDATE
      SET name = $1,
          tier = $2,
          updated_at = $3
      RETURNING *
    """

    {:ok, %{rows: [[id | _]]}} = Ecto.Adapters.SQL.query(App.Repo, query, [data["name"], data["tier"], timestamp])
    {:ok, id}
  end

  defp insert_player(data) do
    query = """
      INSERT INTO players (summoner_id, name, level, profile_icon_id, inserted_at, updated_at)
      VALUES ($1,
              $2,
              30,
              null,
              now(),
              now())
      ON CONFLICT (summoner_id) DO UPDATE
      SET name = $2,
          updated_at = now()
      RETURNING *
    """

    {summoner_id, _} = Integer.parse(data["playerOrTeamId"])
    name = data["playerOrTeamName"]

    {:ok, %{rows: [[id | _]]}} = Ecto.Adapters.SQL.query(App.Repo, query, [summoner_id, name])
    {:ok, id}
  end

  defp get_league(summoner_id) do
    "v2.5/league/by-summoner"
    |> from_url(summoner_id)
    |> fetch
    |> handle_response
    |> handle_leagues
  end

  defp handle_entries([entry | tail], league) do
    {:ok, player_id} = insert_player(entry)

    insert_entry(entry, player_id)

    handle_entries(tail, league)
  end

  defp handle_entries([], _league) do
  end

  defp handle_leagues([{_, [league = %{"queue" => "RANKED_SOLO_5x5"}]} | tail]) do
    {:ok, league_id} = insert_league(league)

    handle_entries(league["entries"], league_id)

    handle_leagues(tail)
  end

  defp handle_leagues([]) do
  end

  defp handle_players([{_, data} | tail]) do
    App.BusyBeaver.get_league(data["id"])

    handle_players(tail)
  end

  defp handle_players([]) do
  end

  defp handle_response(%HTTPotion.Response{body: body, status_code: 200}) do
    body |> parse_json |> Map.to_list
  end

  defp handle_response(%HTTPotion.Response{status_code: 404}) do
    []
  end

  defp handle_response(%HTTPotion.Response{status_code: 429}) do
    Logger.info "[Updater] Rate limited"

    []
  end

  defp parse_json(raw) do
    Poison.Parser.parse!(raw)
  end

  defp timestamp do
    {_, timestamp} = Ecto.DateTime.utc(:usec) |> Ecto.DateTime.dump
    timestamp
  end
end
