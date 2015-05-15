require 'spec_helper'

describe RiotApi, vcr: true do
  before(:all) { @api = RiotApi.new('na') }

  describe '#by_name' do
    it 'returns a hash with single entry for each valid player' do
      expect(@api.by_name('pentakill').count).to eq 1
    end

    it 'returns multiple information for multiple players' do
      expect(@api.by_name(['pentakill', 'peak']).count).to eq 2
    end

    it 'raises error for an invalid player' do
      expect { @api.by_name('riotfakename') }.to raise_error(RiotApi::NotFoundCode)
    end
  end

  describe '#league_for' do
    it "returns a hash with single entry for a player's league" do
      expect(@api.league_for(442232).count).to eq 1
    end

    it 'can return multiple information for multiple players' do
      expect(@api.league_for([20132258, 442232]).count).to eq 2
    end

    it 'raises error for a player not in a league' do
      expect { @api.league_for(0) }.to raise_error(RiotApi::NotFoundCode)
    end
  end

  describe '#league_for_full' do
    it 'returns a single entry with the full league for a player' do
      expect(@api.league_for_full(442232).count).to eq 1
    end

    it 'can return multiple entries for multiple players' do
      expect(@api.league_for_full([20132258, 442232]).count).to eq 2
    end

    it 'raises error for a player not in a league' do
      expect{ @api.league_for_full(0) }.to raise_error(RiotApi::NotFoundCode)

    end
  end
end
