require 'spec_helper'

feature 'User can search for a player' do
  scenario 'Searching for a player' do
    build_ladder_player(region: 'na', name: 'Peak')
    player = Player.find_by_name('Peak')

    visit root_path
    within('#search') do
      select 'NA', from: 'region'
      fill_in 'name', with: 'Peak'
      click_button 'submit'
    end

    expect(current_path).to eq player_path(summoner_id: player.summoner_id, region: player.region)
    expect(page).to have_text(player.name)
  end
end
