require 'spec_helper'

describe Region do
  describe '#available?' do
    it 'returns true for an available region' do
      expect(Region.available?('na')).to eq true
    end

    it 'returns false for an unavailable region' do
      expect(Region.available?('fake')).to eq false
    end
  end
end
