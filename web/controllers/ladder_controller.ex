defmodule App.LadderController do
  use App.Web, :controller
  require Logger

  def index(conn, _params) do
    conn
    |> assign(:leagues, league_count)
    |> assign(:new, new_count)
    |> assign(:players, players)
    |> assign(:total, total_count)
    |> assign(:updates, update_count)
    |> render("index.html")
  end

  defp players do
  end

  defp league_count do
    Repo.one(from l in App.League, select: count(l.id))
  end

  defp total_count do
    Repo.one(from p in App.Player, select: count(p.id))
  end

  defp new_count do
    Repo.one(from p in App.PlayerRanking, where: p.inserted_at > datetime_add(^Ecto.DateTime.utc, -1, "hour"), select: count(p.id))
  end

  defp update_count do
    Repo.one(from p in App.PlayerRanking, where: p.inserted_at > datetime_add(^Ecto.DateTime.utc, -1, "hour"), select: count(p.id))
  end
end
