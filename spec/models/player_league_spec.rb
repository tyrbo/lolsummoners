require 'spec_helper'

describe PlayerLeague do
  let(:player) { build_stubbed(:player) }
  let(:league) { build_stubbed(:league) }
  let(:player_league) { build_stubbed(:player_league, league: league, player: player) }

  describe "#update_ranking" do
    context "with a league" do
      it "sets the new points value in redis" do
        expect(Redis.current).to receive(:zadd).exactly(2).times
        player_league.update_ranking
      end
    end

    context "without a league" do
      let(:player_league) { build_stubbed(:player_league, player: player) }

      it "returns nil" do
        expect(player_league.update_ranking).to be_nil
      end

      it "does not call redis" do
        expect(Redis.current).to receive(:zadd).exactly(0).times
        player_league.update_ranking
      end
    end
  end

  describe "#delete_ranking" do
    it "removes the points for the player in redis" do
      expect(Redis.current).to receive(:zrem).exactly(2).times
      player_league.delete_ranking
    end
  end
end
