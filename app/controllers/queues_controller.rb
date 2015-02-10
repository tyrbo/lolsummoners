class QueuesController < ApplicationController
  include Tubesock::Hijack

  def show
    hijack do |tubesock|
      key_name = "#{params[:region]}_#{params[:by]}_#{params[:name]}"

      Thread.new do
        current = nil
        i = 0
        20.times do
          current = Redis.current.get("response_#{key_name}")
          unless current.nil?
            tubesock.send_data current
            break
          end
          sleep 0.25
        end

        tubesock.close
      end
    end
  end
end
