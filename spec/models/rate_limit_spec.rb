require 'spec_helper'

FakeRequest = Struct.new(:remote_ip)

describe RateLimit do
  let(:redis) { Redis.current }
  let(:request) { FakeRequest.new('127.0.0.1') }
  let(:limiter) { RateLimit.new(request) }

  describe '#limited?' do
    it 'returns true when a key is limited' do
      limiter.limit!
      expect(limiter.limited?).to be true
    end

    it 'returns false when a key is not limited' do
      expect(limiter.limited?).to be false
    end
  end

  describe '#limit!' do
    it 'sets a key to expire at a certain time' do
      limiter.limit!(10)
      expect(redis.ttl(limiter.key)).to eq 10
    end
  end
end
