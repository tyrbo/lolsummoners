require 'spec_helper'

describe Seeder do
  describe '#process' do
    let(:line) { '{ "_id" : { "$oid" : "531e5288c5ffd8c6afa89913" }, "summoner_id" : 371637, "name" : "kizz", "internalName" : "kizz", "points" : 15, "last_points" : 15, "wins" : 3, "inactive" : 0, "hidden" : 0, "hotStreak" : 0, "freshBlood" : 1, "veteran" : 0, "region" : "LAN", "miniSeries" : "2,0,0,1", "league" : { "hash" : "8BB61621BB5F63AA059F53514118A22DAB829E84", "name" : "Sivir\'s Alliance", "tier" : "BRONZE", "queue" : "RANKED_SOLO_5x5" }, "position" : { "row" : 115858, "rank" : 115819 } }' }
    it 'creates a record from a file line' do
      Seeder.process(line)
      expect(Player.count).to be 1
    end
  end
end
