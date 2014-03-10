require 'spec_helper'

describe RateLimit do
  let(:redis) { Redis.current }

  describe '.limited?' do
    it 'returns true when a key is limited' do
      redis.set('limit_test', true)
      expect(RateLimit.limited?('limit_test')).to be true
    end

    it 'returns false when a key is not limited' do
      expect(RateLimit.limited?('limit_test2')).to be false
    end
  end

  describe '.set' do
    it 'sets a key to expire at a certain time' do
      RateLimit.set('k', 10)
      expect(redis.ttl('k')).to eq 10
    end
  end
end
