require 'spec_helper'

describe Ladder do
  let(:redis) { Redis.current }
  before(:each) do
    redis.flushall
    30.times do
      build_ladder_player(region: 'test')
    end
  end

  describe '.find_players_by_rank' do
    it 'returns a paginated list of summoners' do
      ladder = Ladder.new('test')
      expect(ladder.find_players_by_rank(1).count).to eq 25
      expect(ladder.find_players_by_rank(2).count).to eq 5
    end
  end

  describe '.combine_players_with_rank' do
    it 'returns a list of players and ranks' do
      ladder = Ladder.new('test')
      first_player = ladder.combine_players_with_rank(Player.all).first
      expect(first_player.rank).to eq 0
    end
  end
end
