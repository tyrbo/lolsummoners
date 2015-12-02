class League < ActiveRecord::Base
  has_many :league_entries
  has_many :summoners, through: :league_entries
end
