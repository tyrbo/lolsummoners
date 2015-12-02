FactoryGirl.define do
  factory :league_entry do
    league_points 25
  end

  factory :summoner do
    region "na"

    sequence :name do |n| 
      "Summoner #{n}"
    end

    sequence :summoner_id do |n|
      n
    end

    trait :with_ranking do
      association :league_entry

      transient do
        league_points 25
      end

      after(:create) do |x, e|
        x.league_entry.update(league_points: e.league_points)
        x.update_ranking!
      end
    end
  end
end
