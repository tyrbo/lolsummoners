require 'spec_helper'

describe Ladder do
  let(:redis) { Redis.current }
  before(:each) do
    redis.flushall
  end

  describe '.find_players_by_rank' do
    it 'returns a paginated list of summoners' do
      ladder = Ladder.new('test')
      redis.pipelined do
        100.times do |number|
          redis.zadd('rank_test', number, "#{number}_test")
        end
      end
      expect(ladder.find_players_by_rank(1).count).to eq 25
    end
  end

  describe '.combine_players_with_rank' do
    it 'returns a list of players and ranks' do
      ladder = Ladder.new('test')
      10.times do |number|
        create(:player, summoner_id: number, region: 'test')
        redis.zadd('rank_test', number, "#{number}_test")
      end
      first_player = ladder.combine_players_with_rank(Player.all).first
      expect(first_player.rank).to eq 0
    end
  end
end
