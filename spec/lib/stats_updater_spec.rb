require 'spec_helper'

describe StatsUpdater do
  before(:each) do
    allow_any_instance_of(PlayerLeague).to receive(:update_ranking)
    allow_any_instance_of(PlayerLeague).to receive(:delete_ranking)
  end

  describe "#update" do
    before(:each) do
      league = create(:league)
      create_list(:player_league, 25, league: league)
    end

    it "returns the total for the region" do
      expect(StatsUpdater.new("na").update).to eq 25
    end

    it "sets the total in redis" do
      expect(Redis.current).to receive(:set).with("total_na", 25)
      StatsUpdater.new("na").update
    end
  end

  describe "#update_tier" do
    before(:each) do
      league = create(:league, tier: "GOLD")
      create_list(:player_league, 5, division: "I", league: league)
      create_list(:player_league, 5, division: "II", league: league)
      create_list(:player_league, 5, division: "III", league: league)
      create_list(:player_league, 5, division: "IV", league: league)
      create_list(:player_league, 5, division: "V", league: league)
    end

    it "returns the total for the tier" do
      expect(StatsUpdater.new("na").update_tier("GOLD")).to eq 25
    end

    it "creates or updates a new stats value" do
      expect(Stats.last).to eq nil

      StatsUpdater.new("na").update_tier("GOLD")
      values = JSON.parse(Stats.last.value)

      expect(values["I"]).to eq 5
      expect(values["II"]).to eq 5
      expect(values["III"]).to eq 5
      expect(values["IV"]).to eq 5
      expect(values["V"]).to eq 5
      expect(values["total"]).to eq 25
    end
  end
end
