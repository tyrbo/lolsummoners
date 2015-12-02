class LeagueEntry < ActiveRecord::Base
  belongs_to :league
  belongs_to :summoner
end
