defmodule App.Repo.Migrations.CreatePlayersTable do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :summoner_id, :integer

      timestamps
    end
  end
end
