class AddLeagueIdToLeagueEntry < ActiveRecord::Migration
  def change
    add_reference :league_entries, :league, index: true, foreign_key: true
  end
end
