require 'spec_helper'

feature 'User can view the ladder' do
  before(:each) do
    league_na = create(:league)
    league_euw = create(:league, region: 'euw')

    players = create_list(:player, 30)
    players.each do |player|
      player.region = 'na'
      player.player_league = create(:player_league, player: player, league: league_na)
      player.save
    end

    players = create_list(:player, 5)
    players.each do |player|
      player.region = 'euw'
      player.player_league = create(:player_league, player: player, league: league_euw)
      player.save
    end
  end

  scenario 'Viewing page 1 of the global ladder' do
    visit ladder_path(region: 'all') # defaults are region: all and page: 1
    expect(page).to have_css('tr.ladder', count: 25)
  end

  scenario 'Viewing page 2 of the global ladder' do
    visit ladder_path(region: 'all')
    click_link('Next')
    expect(page).to have_css('tr.ladder', count: 10)
  end

  scenario 'Viewing an individual ladder' do
    visit ladder_path(region: 'euw')
    expect(page).to have_css('tr.ladder', count: 5)
  end
end
