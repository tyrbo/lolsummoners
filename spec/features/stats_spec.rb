require 'spec_helper'

feature 'User can view the stats page' do
  scenario 'viewing the stats page' do
    visit stats_path
    expect(page).to have_text 'Solo Queue Stats'
  end
end
