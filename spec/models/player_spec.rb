require 'spec_helper'

describe Player do
  describe '#find_by_ranked_ids' do
    it 'returns a collection of players' do
      redis_ids = []
      50.times do |n|
        create(:player, summoner_id: n)
        redis_ids << ["#{n}_test", 0]
      end
      expect(Player.find_by_ranked_ids(redis_ids).count).to eq 50
    end
  end
end
