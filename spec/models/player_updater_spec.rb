require 'spec_helper'

describe PlayerUpdater do
  describe '#by_name' do
    it 'returns a result for a single name' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['peak'])
      expect(response.first.count).to eq 1
    end

    it 'returns results for multiple names' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['peak', 'aphromoo'])
      expect(response.first.count).to eq 2
    end

    it 'returns zero results for a bad name' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['riotfakename'])
      expect(response.first.count).to eq 0
    end
  end

  describe '#by_id' do
    it 'returns a result for a single id' do
      p = PlayerUpdater.new('na')
      response = p.by_id([21848947])
      expect(response.first.count).to eq 1
    end

    it 'returns a result for multiple ids' do
      p = PlayerUpdater.new('na')
      response = p.by_id([21848947, 442232])
      expect(response.first.count).to eq 2
    end

    it 'returns zero results for a bad id' do
      p = PlayerUpdater.new('na')
      response = p.by_id([0])
      expect(response.first.count).to eq 0
    end
  end
end
