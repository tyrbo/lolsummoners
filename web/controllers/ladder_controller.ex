defmodule App.LadderController do
  use App.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:leagues, "9.7K")
    |> assign(:new, "23.7K")
    |> assign(:players, players)
    |> assign(:total, "11.4M")
    |> assign(:updates, "44.3K")
    |> render("index.html")
  end

  defp players do
  end
end
