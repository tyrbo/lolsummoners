class QueuesController < ApplicationController
  include Tubesock::Hijack

  def show
    hijack do |tubesock|
      @redis = Redis.new
      key_name = "#{params[:region]}_#{params[:name]}"

      @threads = []
      @threads << beat_thread(key_name, tubesock)
      @threads << subscribe_thread(key_name, tubesock)

      tubesock.onclose do
        close
      end
    end
  end

  private

  def beat_thread(key_name, tubesock)
    Thread.new do
      while
        current = @redis.get("limited_#{key_name}")
        unless current.nil?
          puts "Sending #{current}"
          tubesock.send_data current
          close_if_done(current)
        end
        sleep(0.25)
      end
    end
  end

  def subscribe_thread(key_name, tubesock)
    Thread.new do
      @redis.subscribe(key_name) do |on|
        on.message do |channel, message|
          puts "Sending #{message}"
          tubesock.send_data message
          close_if_done(message)
        end
      end
    end
  end

  def close_if_done(message)
    if message.include?('done') || message == 'fail'
      close
    end
  end

  def close
    @threads.each do |thread|
      thread.kill
    end
    @redis.quit
  end
end
