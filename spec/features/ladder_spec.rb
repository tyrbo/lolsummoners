require 'spec_helper'

feature 'User can view the ladder' do
  let(:redis) { Redis.current }
  before(:each) do
    30.times do |n|
      build_ladder_player(region: 'test')
    end

    5.times do |n|
      build_ladder_player(region: 'test2')
    end
  end

  scenario 'Viewing page 1 of the global ladder' do
    visit ladder_path(region: 'all')
    expect(page).to have_css('tr.ladder', count: 25)
  end

  scenario 'Viewing page 2 of the global ladder' do
    visit ladder_path(region: 'all', page: 2)
    expect(page).to have_css('tr.ladder', count: 10)
  end

  scenario 'Viewing the test2 ladder' do
    visit ladder_path(region: 'test2')
    expect(page).to have_css('tr.ladder', count: 5)
  end

  scenario 'Viewing a region which does not exist' do
    expect {
      visit ladder_path(region: 'fakeregion')
    }.to raise_error(ActionController::RoutingError)
  end
end
