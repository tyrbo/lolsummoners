include ApplicationHelper

def player_with_league(opts = {})
  p = create(:player)
  opts.merge!({player: p})
  player_league = create(:player_league, opts)
  p.player_league = player_league
  p.save
  p
end
