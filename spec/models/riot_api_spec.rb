require 'spec_helper'

describe RiotApi do
  describe '#by_name' do
    it 'returns a single response for a valid player' do
      expect(RiotApi.new('na').by_name(['pentakill']).count).to eq 1
    end

    it 'returns {} for an invalid player' do
      expect(RiotApi.new('na').by_name(['riotfakename'])).to eq Hash.new
    end
  end

  describe '#league_for' do
    it 'returns a hash for a player in a league' do
      expect(RiotApi.new('na').league_for([21848947]).count).to eq 1
    end

    it 'returns nil for a player not in a league' do
      expect(RiotApi.new('na').league_for([0])).to eq Hash.new
    end
  end
end
