defmodule App.Player do
  use Ecto.Model

  schema "players" do
    field :summoner_id, :integer
    field :name, :string
    field :level, :integer
    field :profile_icon_id, :integer

    has_one :player_ranking, App.PlayerRanking

    timestamps
  end
end
