require 'spec_helper'

describe PlayerUpdater, vcr: true do
  describe '#initialize' do
    it 'should require a region as an argument' do
      expect { PlayerUpdater.new }.to raise_error(ArgumentError)
    end
  end
  
  describe '#by_name' do
    it 'returns a result for a single name' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['pentakill'])
      expect(response.count).to eq 1
    end

    it 'returns results for multiple names' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['pentakill', 'aphromoo'])
      expect(response.count).to eq 2
    end

    it 'returns zero results for a bad name' do
      p = PlayerUpdater.new('na')
      response = p.by_name(['riotfakename'])
      expect(response.count).to eq 0
    end
  end

  describe '#by_id' do
    it 'returns a result for a single id' do
      p = PlayerUpdater.new('na')
      response = p.by_id([21848947])
      expect(response.count).to eq 1
    end

    it 'returns a result for multiple ids' do
      p = PlayerUpdater.new('na')
      response = p.by_id([21848947, 442232])
      expect(response.count).to eq 2
    end

    it 'returns zero results for a bad id' do
      p = PlayerUpdater.new('na')
      response = p.by_id([0])
      expect(response.count).to eq 0
    end
  end
end
