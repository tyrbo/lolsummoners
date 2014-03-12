class QueuesController < ApplicationController
  include Tubesock::Hijack

  def show
    hijack do |tubesock|
      @redis = Redis.new
      key_name = "#{params[:region]}_#{params[:name]}"

      @beat = Thread.new do
        current = ''
        while 1 do
          current = @redis.get("limited_#{key_name}")
          unless current.nil?
            tubesock.send_data current
            break
          end
          sleep(0.25)
        end
      end

      @sub = Thread.new do
        @redis.subscribe(key_name) do |on|
          on.message do |channel, message|
            tubesock.send_data message
            break
          end
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
    @beat.kill
    @sub.kill
  end
end
