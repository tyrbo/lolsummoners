class ErrorWatch
  def self.check
    begin
      player = PlayerLeague.new
      PlayerLeague.all.find_each do |player|
        r = player.region
      end
    rescue StandardError => error
      puts "Bad: #{player.player_id}"
    end
  end
end
