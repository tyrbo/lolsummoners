require 'spec_helper'

feature 'User can view a league' do
  before(:each) do
    30.times do |n|
      build_ladder_player(region: 'na')
    end
  end

  scenario 'Navigating through a ladder' do
    visit ladder_path(region: 'all')
    within('tr.ladder:first') do
      find('a').click
    end
    expect(page).to have_text("Peak's Testers")
  end

  scenario 'Visiting a league directly' do
    league = League.first
    visit league_path(region: 'na', id: league.id)
    expect(page).to have_text(league.name)
  end
end
