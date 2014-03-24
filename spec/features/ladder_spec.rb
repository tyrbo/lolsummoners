require 'spec_helper'

feature 'User can view the ladder' do
  before(:each) do
    30.times do |n|
      build_ladder_player(region: 'na')
    end

    5.times do |n|
      build_ladder_player(region: 'euw')
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
