defmodule App.Repo.Migrations.CreatePlayerRankings do
  use Ecto.Migration

  def change do
    create table(:player_rankings) do
      add :division, :string
      add :is_fresh_blood, :boolean
      add :is_hot_streak, :boolean
      add :is_inactive, :boolean
      add :is_veteran, :boolean
      add :league_points, :integer
      add :losses, :integer
      add :wins, :integer
      add :player_id, references(:players, on_delete: :delete_all)

      timestamps
    end

    create index(:player_rankings, [:player_id], unique: true)
  end
end
