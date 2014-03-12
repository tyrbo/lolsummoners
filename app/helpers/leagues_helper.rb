module LeaguesHelper
  def points_for(player)
    unless player.mini_series.nil?
      target, wins, losses, time_left = player.mini_series.split(',')
      target, wins, losses = target.to_i, wins.to_i, losses.to_i
      total = if target == 2 then 3 else 5 end
      togo = total - wins - losses
      str = []
      wins.times { str << '<div class="best-of win"></div>' }
      losses.times { str << '<div class="best-of loss"></div>' }
      togo.times { str << '<div class="best-of blank"></div>' }
      return str.join.html_safe
    else
      player.league_points
    end
  end
end
