require 'spec_helper'

describe PlayerLeagueUpdater, vcr: true do
  describe '#initialize' do
    it 'should require a region as an argument' do
      expect { Updater.new }.to raise_error(ArgumentError)
    end
  end

  describe '#by_player' do
    it 'requires a Player' do
      expect { PlayerLeagueUpdater.new('na').update }.to raise_error ArgumentError
    end

    it 'updates the PlayerLeague for the given Players' do
      player = create(:player, summoner_id: 442232, region: 'na')
      p = PlayerLeagueUpdater.new('na')
      p.by_player([player])
      expect(PlayerLeague.count).to eq 1
    end
  end
end
