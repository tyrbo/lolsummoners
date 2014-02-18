require 'spec_helper'

feature 'User can visit the home page' do
  scenario 'Viewing the home page' do
    visit root_path
    expect(page).to have_title 'League of Legends Stats and Rankings | LOL Summoners'
  end
end
