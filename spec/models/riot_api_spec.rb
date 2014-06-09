require 'spec_helper'

describe RiotApi do
  describe '#by_name' do
    it 'returns a hash for a valid player' do
      expected_hash = [{'pentakill' => {
        'id' => 0,
        'name' => 'Pentakill',
        'profileIconId' => 28,
        'revisionDate' => 0,
        'summonerLevel' => 30
      }}]
      expect(RiotApi.new('na').by_name(['pentakill'])).to eq expected_hash
    end

    it 'returns nil for an invalid player' do
      expect(RiotApi.new('na').by_name(['ajsdfoabsdfouabsdfiouweroi'])).to eq [nil]
    end
  end

  describe '#league_for' do
    it 'returns a hash for a player in a league' do
      expected_hash = [{"21848947" => [{
        "name" => "Tryndamere's Deceivers",
        "tier" => "GOLD",
        "queue" => "RANKED_SOLO_5x5",
        "entries" => [{
          "playerOrTeamId" => "21848947",
          "playerOrTeamName" => "Peak",
          "division" => "I",
          "leaguePoints" => 30,
          "wins" => 52,
          "isHotStreak" => false,
          "isVeteran" => false,
          "isFreshBlood" => false,
          "isInactive" => false
        }]
      }]}]
      expect(RiotApi.new('na').league_for([21848947])).to eq expected_hash
    end

    it 'returns nil for a player not in a league' do
      expect(RiotApi.new('na').league_for([0])).to eq [nil]
    end
  end
end
