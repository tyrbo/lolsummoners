class League < ActiveRecord::Base
  has_many :league_entries, dependent: :destroy
  has_many :summoners, through: :league_entries
end
