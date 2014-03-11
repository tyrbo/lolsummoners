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
          puts "Current: #{current}"
          unless current.nil?
            tubesock.send_data current
            break
          end
          sleep(0.25)
        end
        sleep(0.25)
        tubesock.close
      end

      @sub = Thread.new do
        @redis.subscribe(key_name) do |on|
          on.message do |channel, message|
            puts "Message: #{message}"
            tubesock.send_data message
            tubesock.close
            break
          end
        end
      end

      tubesock.onopen do
        puts "Opened"
      end

      tubesock.onclose do
        puts "Closed"
      end
    end
  end

  private

  def subscribe_thread(key_name, tubesock)
  end

  def close
    @redis.quit
    @beat.kill
    @sub.kill
  end
end
