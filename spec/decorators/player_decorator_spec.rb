require 'spec_helper'

describe PlayerDecorator do
  let(:league) { build_stubbed(:league) }
  let(:player_league) { build_stubbed(:player_league, league_points: 1234, league: league) }
  let(:player) { build_stubbed(:player, rank: 14823, player_league: player_league).decorate }

  describe "#formatted_region" do
    it "returns an upcased region" do
      expect(player.formatted_region).to eq "TEST"
    end
  end

  describe "#formatted_rank" do
    it "returns a comma formatted rank" do
      expect(player.formatted_rank).to eq "14,823"
    end
  end

  describe "#formatted_league_points" do
    it "returns comma formatted league points" do
      expect(player.formatted_league_points).to eq "1,234"
    end
  end

  describe "#formatted_tier" do
    it "returns a capitalized tier" do
      expect(player.formatted_tier).to eq "Challenger"
    end
  end

  describe "#percentile" do
    it "returns the percentile for the player" do
      expect(Stats).to receive(:total_for).with("test").and_return(14823)
      expect(player.percentile("test")).to eq "100.00"
    end

    context "with a percentile below 0.01" do
      it "returns 0.01" do
        expect(Stats).to receive(:total_for).with("test").and_return(100000000)
        expect(player.percentile("test")).to eq "0.01"
      end
    end
  end
end
