require 'spec_helper'

feature 'User can view the ladder' do
  let(:redis) { Redis.current }
  before(:each) do
    5.times do |n|
      build_ladder_player(region: 'test')
    end
  end

  scenario 'Viewing the global ladder' do
    visit ladder_path('all')
    expect(page).to have_css('tr.ladder', count: 5)
  end
end
