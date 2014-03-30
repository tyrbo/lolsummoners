require 'spec_helper'

feature 'User can view a league' do
  before(:each) do
    league = create(:league)
    player = create(:player, region: 'na')
    player.region = 'na'
    player.player_league = create(:player_league, player: player, league: league)
    player.save
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
