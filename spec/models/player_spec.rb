require 'spec_helper'

describe Player do
  describe '#find_players_by_region' do
    it 'returns a collection of players' do
      redis_ids = []
      players = create_list(:player, 50)
      players.each do |player|
        redis_ids << ["#{player.summoner_id}_test", 0]
      end
      expect(Player.find_players_by_region(redis_ids).count).to eq 50
    end
  end
end
