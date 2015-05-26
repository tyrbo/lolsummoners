require 'spec_helper'

describe League do
  describe '.add_points_for_tier' do
    it 'should return 0 for BRONZE' do
      expect(League.add_points_for_tier('BRONZE')).to eq 0
    end
    it 'should return 5000 for SILVER' do
      expect(League.add_points_for_tier('SILVER')).to eq 5000
    end
    it 'should return 10000 for GOLD' do
      expect(League.add_points_for_tier('GOLD')).to eq 10000
    end
    it 'should return 15000 for PLATINUM' do
      expect(League.add_points_for_tier('PLATINUM')).to eq 15000
    end
    it 'should return 20000 for DIAMOND' do
      expect(League.add_points_for_tier('DIAMOND')).to eq 20000
    end
    it 'should return 25000 for MASTER' do
      expect(League.add_points_for_tier('MASTER')).to eq 25000
    end
    it 'should return 30000 for CHALLENGER' do
      expect(League.add_points_for_tier('CHALLENGER')).to eq 30000
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

  describe ".rank_from_points" do
    it "should return I for 3900" do
      expect(League.rank_from_points(3900)).to eq "I"
    end

    it "should return II for 2900" do
      expect(League.rank_from_points(2900)).to eq "II"
    end

    it "should return III for 1900" do
      expect(League.rank_from_points(1900)).to eq "III"
    end

    it "should return IV for 900" do
      expect(League.rank_from_points(900)).to eq "IV"
    end

    it "should return V for 899" do
      expect(League.rank_from_points(899)).to eq "V"
    end
  end
end
