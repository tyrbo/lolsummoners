require "rails_helper"

FactoryGirl.describe LeagueEntry do
  context "associations" do
    it { should belong_to(:summoner) }
  end
end
