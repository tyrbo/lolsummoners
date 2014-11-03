class QueuesController < ApplicationController
  include Tubesock::Hijack

  def show
    hijack do |tubesock|
      host = ENV['REDIS_HOST'] || '127.0.0.1'
      @redis = Redis.new(host: host)
      key_name = "#{params[:region]}_#{params[:by]}_#{params[:name]}"

      Thread.new do
        current = nil
        i = 0
        20.times do
          current = @redis.get("response_#{key_name}")
          unless current.nil?
            tubesock.send_data current
            break
          end
          sleep 0.25
        end

        tubesock.close
      end

      tubesock.onclose do
        close
      end
    end
  end

  private

  def close
    @redis.quit
  end
end
