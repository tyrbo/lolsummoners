defmodule App.Repo.Migrations.AddLeaguesTable do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :tier, :string

      timestamps
    end

    create index(:leagues, [:name, :tier], unique: true)
  end
end
