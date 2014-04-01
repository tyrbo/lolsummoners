# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    sequence(:summoner_id) {|n| n}
    sequence(:name) {|n| "Summoner#{n}"}
    profile_icon_id 1
    revision_date 1
    summoner_level 30
    region 'test'
  end
end
