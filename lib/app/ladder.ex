defmodule App.Ladder do
  alias RedisPoolex, as: Redis
  import Ecto.Query

  @max_per_page 25

  def load_page(page \\ 1) when page > 0 do
    page
    |> fetch_from_redis
    |> clean_ids
    |> fetch_players
  end

  defp clean_ids(ids) when is_list(ids) do
    ids
    |> Enum.map(fn(x) -> String.replace(x, ~r/[^0-9]/, "") end)
  end

  defp fetch_players([]), do: []

  defp fetch_players(players) when is_list(players) do
    query = from p in App.Player, where: p.summoner_id in ^players

    query
    |> App.Repo.all
    |> App.Repo.preload(:player_ranking)
  end

  defp fetch_from_redis(page) do
    Redis.query(["zrevrange",
      "rank_na",
      (page - 1) * @max_per_page,
      (page * @max_per_page) - 1
    ])
  end
end
