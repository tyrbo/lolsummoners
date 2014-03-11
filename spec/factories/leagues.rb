# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :league do
    name "Peak's Testers"
    queue "RANKED_SOLO_5x5"
    tier "Challenger"
    region "na"
  end
end
