require 'spec_helper'

describe ApiHandler do
  let(:handler) { ApiHandler.new('na') }

  describe '#player_search' do
    it 'creates a new player' do
      handler.player_search('id' => 'pentakill', 'by' => 'name')
      expect(Player.count).to eq 1
    end

    it 'updates an existing player' do
      build_ladder_player(region: 'na', name: 'PeAk', summoner_id: 21848947)
      handler.player_search('id' => 'peak', 'by' => 'name')
      player = Player.name_and_region('peak', 'na').first
      expect(player.name).to eq 'Peak'
    end
  end
end
