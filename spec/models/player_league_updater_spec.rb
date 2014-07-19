require 'spec_helper'

describe PlayerLeagueUpdater, vcr: true do
  describe '#initialize' do
    it 'should require a region as an argument' do
      expect { Updater.new }.to raise_error(ArgumentError)
    end
  end

  describe '#by_player' do
    it 'requires a player' do
      expect { PlayerLeagueUpdater.new('na').update }.to raise_error ArgumentError
    end

    it 'updates the PlayerLeague for the given player' do
      player = create(:player, summoner_id: 442232, region: 'na')
      p = PlayerLeagueUpdater.new('na')
      p.by_player([player])
      expect(PlayerLeague.count).to eq 200
    end

    it 'updates the PlayerLeague for the given players' do
      player1 = create(:player, summoner_id: 442232, region: 'na')
      player2 = create(:player, summoner_id: 21848947, region: 'na')

      p = PlayerLeagueUpdater.new('na')
      p.by_player([player1, player2])

      expect(PlayerLeague.all.map(&:player_or_team_id)).to include('21848947', '442232')
      expect(PlayerLeague.count).to eq 378
    end
  end
end
