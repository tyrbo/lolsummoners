# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player_league do
    is_fresh_blood false
    is_hot_streak false
    is_inactive false
    is_veteran false
    last_played 1
    league_points 1
    mini_series nil
    player_or_team_id 'MyString'
    player_or_team_name ''
    queue 'RANKED_SOLO_5X5'
    rank 'I'
    tier 'CHALLENGER'
    wins 1
  end
end
