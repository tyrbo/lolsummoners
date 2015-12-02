require "rails_helper"

RSpec.feature "Visitor" do
  scenario "views ladder" do
    summoner = FactoryGirl.create(:summoner, :with_ranking)

    visit ladder_path

    expect(page).to have_content(summoner.name)
  end

  scenario "Views next page" do
    FactoryGirl.create_list(:summoner, 45, :with_ranking)

    visit ladder_path
    click_link "Next"

    expect(page).to have_selector("tr.summoner", count: 20)
  end

  scenario "Views previous page" do
    FactoryGirl.create_list(:summoner, 45, :with_ranking)

    visit ladder_path(region: "all", page: 2)
    click_link "Prev"

    expect(page).to have_selector("tr.summoner", count: 25)
  end
end
