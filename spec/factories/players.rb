# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    summoner_id 1
    name "SummonerName"
    profile_icon_id 1
    revision_date 1
    summoner_level 30
    region 'test'
  end
end
