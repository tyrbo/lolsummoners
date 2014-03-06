require 'spec_helper'

feature 'User can view the ladder' do
  let(:redis) { Redis.current }
  before(:each) do
    Redis.current.flushall

    30.times do |n|
      build_ladder_player(region: 'test')
    end

    5.times do |n|
      build_ladder_player(region: 'test2')
    end
  end

  scenario 'Viewing page 1 of the global ladder' do
    visit ladder_path(id: 'all') # defaults are region: all and page: 1
    expect(page).to have_css('tr.ladder', count: 25)
  end

  scenario 'Viewing page 2 of the global ladder' do
    visit ladder_path(id: 'all')
    click_link('Next')
    expect(page).to have_css('tr.ladder', count: 10)
  end

  scenario 'Viewing an individual ladder' do
    visit ladder_path(id: 'test2')
    expect(page).to have_css('tr.ladder', count: 5)
  end
end
