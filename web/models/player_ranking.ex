defmodule App.PlayerRanking do
  use Ecto.Model

  schema "player_rankings" do
    field :division, :string
    field :is_fresh_blood, :boolean
    field :is_hot_streak, :boolean
    field :is_inactive, :boolean
    field :is_veteran, :boolean
    field :league_points, :integer
    field :losses, :integer
    field :wins, :integer

    belongs_to :player, App.Player

    timestamps
  end
end
