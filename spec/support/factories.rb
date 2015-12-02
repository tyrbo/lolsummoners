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

      after(:create) do |x|
        x.update_ranking!
      end
    end
  end
end
