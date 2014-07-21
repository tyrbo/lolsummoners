require 'spec_helper'

describe Updater, vcr: true do
  describe '#initialize' do
    it 'should require a region as an argument' do
      expect { Updater.new }.to raise_error(ArgumentError)
    end
  end

  describe '#by_id' do
    it 'should update only a player when league is false' do
      u = Updater.new('na')
      u.by_id([21848947], false)
      expect(Player.count).to eq 1
      expect(PlayerLeague.count).to eq 0
    end
  end

  describe '#by_name' do
    it 'should update only a player when league is false' do
      u = Updater.new('na')
      u.by_name(['peak'], false)
      expect(Player.count).to eq 1
      expect(PlayerLeague.count).to eq 0
    end
  end
end
