include ApplicationHelper

def build_ladder(opts)
  count = opts[:count]
  region = opts[:region]

  count.times do |n|
    player = build(:player, summoner_id: n, region: region)
  end
end
