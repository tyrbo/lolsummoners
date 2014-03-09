require 'spec_helper'

describe RiotApi do
  describe '#by_name' do
    let(:api) { RiotApi.new('na') }

    it 'returns a hash for a valid player' do
      expected_hash = {
        "id" => 1,
        "name" => "Pentakill",
        "profileIconId" => 28,
        "revisionDate" => 0,
        "summonerLevel" => 30
      }
      expect(api.by_name('pentakill')).to eq expected_hash
    end

    it 'returns nil for an invalid player' do
      expect(api.by_name('ajsdfoabsdfouabsdfiouweroi')).to eq nil
    end
  end
end
