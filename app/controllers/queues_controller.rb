class QueuesController < ApplicationController
  include Tubesock::Hijack

  def show
    hijack do |tubesock|
      @redis = Redis.new
      key_name = "#{params[:region]}_#{params[:name]}"

      Thread.new do
        current = nil
        loop do
          current = @redis.get("response_#{key_name}")
          unless current.nil?
            tubesock.send_data current
            break
          end
          sleep 0.25
        end
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
