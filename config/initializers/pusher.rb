require 'pusher'

Pusher.url = "http://f1f712c95f23e54a53b0:#{ENV["PUSHER_SECRET"]}@api.pusherapp.com/apps/118303"
Pusher.logger = Rails.logger
