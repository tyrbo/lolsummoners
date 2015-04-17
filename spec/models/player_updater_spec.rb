require 'spec_helper'

describe PlayerUpdater do
  describe '#initialize' do
    it 'should require an api and region as an argument' do
      expect { PlayerUpdater.new }.to raise_error(ArgumentError)
    end
  end
  
  describe '#by_name' do
    it 'returns a result for a single name' do
      api = double('riot api', by_name: { 'pentakill' => {} })
      player_updater = PlayerUpdater.new(api, 'na')

      response = player_updater.by_name(['pentakill'])

      expect(api).to have_received(:by_name).exactly(:once)
      expect(response.count).to eq 1
    end

    it 'splits calls into sets of 40' do
      api = double('riot api')
      allow(api).to receive(:by_name)
      player_updater = PlayerUpdater.new(api, 'na')
      players = Array.new(41) { 'a' }

      response = player_updater.by_name(players)

      expect(api).to have_received(:by_name).exactly(:twice)
    end
  end

  describe '#by_id' do
    it 'returns a result for a single id' do
      api = double('riot api', by_summoner_id: { 21848947 => {} })
      player_updater = PlayerUpdater.new(api, 'na')

      response = player_updater.by_id([21848947])

      expect(api).to have_received(:by_summoner_id).exactly(:once)
      expect(response.count).to eq 1
    end

    it 'splits calls into sets of 40' do
      api = double('riot api')
      allow(api).to receive(:by_summoner_id)
      player_updater = PlayerUpdater.new(api, 'na')
      ids = Array.new(41) { 1 }

      response = player_updater.by_id(ids)

      expect(api).to have_received(:by_summoner_id).exactly(:twice)
    end
  end
end
