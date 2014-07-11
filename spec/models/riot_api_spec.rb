require 'spec_helper'

describe RiotApi, vcr: true do
  before(:all) { @api = RiotApi.new('na') }

  describe '#by_name' do
    it 'returns a hash with single entry for each valid player' do
      expect(@api.by_name(['pentakill']).count).to eq 1
    end

    it 'returns multiple information for multiple players' do
      expect(@api.by_name(['pentakill', 'peak']).count).to eq 2
    end

    it 'returns {} for an invalid player' do
      expect(@api.by_name(['riotfakename'])).to eq Hash.new
    end
  end

  describe '#league_for' do
    it "returns a hash with single entry for a player's league" do
      expect(@api.league_for([21848947]).count).to eq 1
    end

    it 'can return multiple information for multiple players' do
      expect(@api.league_for([21848947, 442232]).count).to eq 2
    end

    it 'returns {} for a player not in a league' do
      expect(@api.league_for([0])).to eq Hash.new
    end
  end

  describe '#league_for_full' do
    it 'returns a single entry with the full league for a player' do
      expect(@api.league_for_full([21848947]).count).to eq 1
    end

    it 'can return multiple entries for multiple players' do
      expect(@api.league_for_full([21848947, 442232]).count).to eq 2
    end

    it 'returns {} for a player not in a league' do
      expect(@api.league_for_full([0])).to eq Hash.new
    end
  end
end
