require "rails_helper"

RSpec.describe Summoner do
  describe "#delete_ranking!" do
    it "deletes the ranking for a player" do
      summoner = FactoryGirl.create(:summoner, :with_ranking)

      summoner.delete_ranking!

      expect(summoner.rank).to be nil
    end
  end
end
