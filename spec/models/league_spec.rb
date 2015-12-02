require "rails_helper"

RSpec.describe League do
  context "associations" do
    it { should have_many(:league_entries) }
    it { should have_many(:summoners).through(:league_entries) }
  end
end
