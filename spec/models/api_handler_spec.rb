require 'spec_helper'

describe ApiHandler do
  let(:handler) { ApiHandler.new('na') }

  describe '#api_for' do
    it 'uses RiotApi when region is available' do
      expect(handler.api_for('na')).to be_kind_of RiotApi
    end

    it 'uses NodeApi when region api is unavailable' do
      expect(handler.api_for('euw')).to be_kind_of NodeApi
    end
  end

  describe '#player_search' do
    it 'creates a new player' do
      handler.player_search('pentakill')
      expect(Player.count).to eq 1
    end

    it 'updates an existing player' do
      build_ladder_player(region: 'na', name: 'PeAk', summoner_id: 21848947)
      handler.player_search('peak')
      player = Player.name_and_region('peak', 'na').first
      expect(player.name).to eq 'Peak'
    end

    it 'cannot search for the same player too frequently' do
      expect(handler.player_search('peak')).to eq true
      expect(handler.player_search('peak')).to eq false
    end
  end
end
