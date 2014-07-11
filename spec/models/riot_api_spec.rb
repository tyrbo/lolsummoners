require 'spec_helper'

describe RiotApi do
  describe '#by_name' do
    it 'returns a hash for a valid player' do
      expected_hash = [{
        'id' => 0,
        'name' => 'Pentakill',
        'profileIconId' => 28,
        'revisionDate' => 0,
        'summonerLevel' => 30
      }, 200]
      expect(RiotApi.new('na').by_name('pentakill')).to eq expected_hash
    end

    it 'returns nil for an invalid player' do
      expect(RiotApi.new('na').by_name('ajsdfoabsdfouabsdfiouweroi')).to eq [nil, 404]
    end
  end

  describe '#league_for' do
    it 'returns a hash for a player in a league' do
      expected_hash = [{
        'name' => 'asdf',
        'queue' => 'RANKED_SOLO_5x5',
        'tier' => 'GOLD',
        'entries' => [{
          'isHotStreak' => false,
          'isFreshBlood' => false,
          'isVeteran' => false,
          'lastPlayed' => -1,
          'playerOrTeamId' => '21848947',
          'leaguePoints' => 37,
          'division' => 'IV',
          'isInactive' => false,
          'playerOrTeamName' => 'Peak',
          'wins' => 7
        }]
      }, 200]
      expect(RiotApi.new('na').league_for(21848947)).to eq expected_hash
    end

    it 'returns nil for a player not in a league' do
      expect(RiotApi.new('na').league_for(0)).to eq [nil, 404]
    end
  end
end
