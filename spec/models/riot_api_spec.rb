require 'spec_helper'

describe RiotApi do
  let(:api) { RiotApi.new('na') }

  describe '#by_name' do
    it 'returns a hash for a valid player' do
      expected_hash = {
        'id' => 0,
        'name' => 'Pentakill',
        'profileIconId' => 28,
        'revisionDate' => 0,
        'summonerLevel' => 30
      }
      expect(api.by_name('pentakill')).to eq expected_hash
    end

    it 'returns nil for an invalid player' do
      expect(api.by_name('ajsdfoabsdfouabsdfiouweroi')).to eq nil
    end
  end

  describe '#league_for' do
    it 'returns a hash for a player in a league' do
      expected_hash = {
        'isHotStreak' => false,
        'isFreshBlood' => false,
        'leagueName' => "Taric's Zealots",
        'isVeteran' => false,
        'tier' => 'PLATINUM',
        'lastPlayed' => -1,
        'playerOrTeamId' => '21848947',
        'leaguePoints' => 37,
        'rank' => 'IV',
        'isInactive' => false,
        'queueType' => 'RANKED_SOLO_5x5',
        'playerOrTeamName' => 'Peak',
        'wins' => 7
      }
      expect(api.league_for(21848947)).to eq expected_hash
    end

    it 'returns nil for a player not in a league' do
      expect(api.league_for(0)).to eq nil
    end
  end
end
