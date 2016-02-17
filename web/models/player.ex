defmodule App.Player do
  use Ecto.Model

  schema "players" do
    field :summoner_id, :integer

    field :inserted_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc
  end
end
