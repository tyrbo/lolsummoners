require 'spec_helper'

describe League do
  describe '.add_points_for_tier' do
    it 'should return 0 for BRONZE' do
      expect(League.add_points_for_tier('BRONZE')).to eq 0
    end
    it 'should return 5000 for SILVER' do
      expect(League.add_points_for_tier('SILVER')).to eq 5000
    end
    it 'should return 0 for GOLD' do
      expect(League.add_points_for_tier('GOLD')).to eq 10000
    end
    it 'should return 0 for PLATINUM' do
      expect(League.add_points_for_tier('PLATINUM')).to eq 15000
    end
    it 'should return 0 for DIAMOND' do
      expect(League.add_points_for_tier('DIAMOND')).to eq 20000
    end
    it 'should return 25000 for CHALLENGER' do
      expect(League.add_points_for_tier('CHALLENGER')).to eq 25000
    end
  end

  describe '.add_points_for_rank' do
    it 'should return 4000 for I' do
      expect(League.add_points_for_rank('I')).to eq 4000
    end
    it 'should return 3000 for II' do
      expect(League.add_points_for_rank('II')).to eq 3000
    end
    it 'should return 2000 for I' do
      expect(League.add_points_for_rank('III')).to eq 2000
    end
    it 'should return 1000 for I' do
      expect(League.add_points_for_rank('IV')).to eq 1000
    end
    it 'should return 0 for I' do
      expect(League.add_points_for_rank('V')).to eq 0
    end
  end
end
