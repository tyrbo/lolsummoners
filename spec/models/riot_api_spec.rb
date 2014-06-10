require 'spec_helper'

describe RiotApi, vcr: true do
  describe '#by_name' do
    it 'returns a hash with single entry for each valid player' do
      expect(RiotApi.new('na').by_name(['pentakill']).count).to eq 1
    end

    it 'returns {} for an invalid player' do
      expect(RiotApi.new('na').by_name(['riotfakename'])).to eq Hash.new
    end
  end

  describe '#league_for' do
    it "returns a hash with single entry for a player's league" do
      expect(RiotApi.new('na').league_for([21848947]).count).to eq 1
    end

    it 'returns {} for a player not in a league' do
      expect(RiotApi.new('na').league_for([0])).to eq Hash.new
    end
  end
end
