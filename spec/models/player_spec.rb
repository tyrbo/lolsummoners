require 'spec_helper'

describe Player do
  describe '#find_players_by_region' do
    it 'returns a collection of players' do
      redis_ids = []
      50.times do |n|
        create(:player, summoner_id: n, region: 'test')
        redis_ids << ["#{n}_test", 0]
      end
      expect(Player.find_players_by_region(redis_ids).count).to eq 50
    end
  end
end
