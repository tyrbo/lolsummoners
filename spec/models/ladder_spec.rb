require "rails_helper"

FactoryGirl.describe Ladder do
  describe "#fetch" do
    it "returns the summoners for the given parameters" do
      FactoryGirl.create_list(:summoner, 7, :with_ranking, region: "na")
      FactoryGirl.create_list(:summoner, 3, :with_ranking, region: "euw")

      ladder = Ladder.new(page: 1, region: "na")
      ladder.fetch

      expect(ladder.summoners.size).to eq 7
    end
  end
  describe "#has_next_page?" do
    let(:ladder) { Ladder.new(page: 1) }

    it "returns true when the next page is available" do
      allow(ladder).to receive(:total_summoners).and_return(26)

      expect(ladder.has_next_page?).to be true
    end

    it "returns false when the next page is unavailable" do
      allow(ladder).to receive(:total_summoners).and_return(1)

      expect(ladder.has_next_page?).to be false
    end
  end

  describe "#has_prev_page?" do
    it "returns true when the previous page is available" do
      ladder = Ladder.new(page: 2)

      expect(ladder.has_prev_page?).to be true
    end

    it "returns false when the previous page is unavailable" do
      ladder = Ladder.new(page: 1)

      expect(ladder.has_next_page?).to be false
    end
  end

  describe "#next_page" do
    it "returns the value of the next page" do
      ladder = Ladder.new(page: 1)

      expect(ladder.next_page).to eq 2
    end
  end

  describe "#prev_page" do
    it "returns the value of the previous page" do
      ladder = Ladder.new(page: 2)

      expect(ladder.prev_page).to eq 1
    end
  end

  describe "#total_summoners" do
    it "returns the number of summoners for a given region" do
      FactoryGirl.create_list(:summoner, 4, :with_ranking)

      ladder = Ladder.new(region: "all")

      expect(ladder.total_summoners).to eq 4
    end
  end
end
