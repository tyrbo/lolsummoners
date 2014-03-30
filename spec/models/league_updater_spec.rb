require 'spec_helper'

describe LeagueUpdater do
  describe '#update' do
  end

  describe '#find_player_to_update' do
    it 'returns a player to update' do
      player_with_league(updated_at: 35.minutes.ago)
      player = LeagueUpdater.new.find_player_to_update
      expect(player).to_not be nil
    end

    it 'returns a zero count when no player found' do
      player = LeagueUpdater.new.find_player_to_update
      expect(player).to be nil
    end
  end
end
