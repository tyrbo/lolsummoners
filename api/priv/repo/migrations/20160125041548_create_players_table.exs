defmodule App.Repo.Migrations.CreatePlayersTable do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :summoner_id, :integer
      add :name, :string
      add :level, :integer
      add :profile_icon_id, :integer

      timestamps
    end

    create index(:players, [:summoner_id], unique: true)
  end
end
