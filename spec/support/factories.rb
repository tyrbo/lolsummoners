FactoryGirl.define do
  factory :summoner do
    region "na"

    sequence :name do |n| 
      "Summoner #{n}"
    end

    sequence :summoner_id do |n|
      n
    end

    trait :with_ranking do
      after(:create) do |x|
        x.update_ranking!
      end
    end
  end
end
