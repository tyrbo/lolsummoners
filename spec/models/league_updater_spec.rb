require 'spec_helper'

describe LeagueUpdater do
  describe '#update_players' do
    it 'updates the given player' do
      player = player_with_league(player_or_team_id: '442232', updated_at: 31.hours.ago)
      player.region = 'na'
      player.summoner_id = 442232
      player.save

      updater = LeagueUpdater.new
      player = updater.find_player_to_update
      updater.update_players(player)

      player = Player.includes(:player_league).summoner_id_and_region(442232, 'na').first
      expect(player.name).to eq 'aphromoo'
    end

    it 'creates or updates additional players' do
      player = player_with_league(player_or_team_id: '442232', updated_at: 31.hours.ago)
      player.region = 'na'
      player.summoner_id = 442232
      player.save

      updater = LeagueUpdater.new
      player = updater.find_player_to_update
      updater.update_players(player)

      player = Player.includes(:player_league).summoner_id_and_region(23459413, 'na').first
      expect(player.name).to eq 'Suffix'
    end
  end

  describe '#find_player_to_update' do
    it 'returns a player to update' do
      player_with_league(updated_at: 31.hours.ago)
      player = LeagueUpdater.new.find_player_to_update
      expect(player).to_not be nil
    end

    it 'returns a zero count when no player found' do
      player = LeagueUpdater.new.find_player_to_update
      expect(player).to be nil
    end
  end
end
