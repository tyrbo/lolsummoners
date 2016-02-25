defmodule App.League do
  use Ecto.Model

  schema "leagues" do
    field :name, :string
    field :tier, :string

    timestamps
  end
end
