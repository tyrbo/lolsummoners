require 'spec_helper'

feature 'User can search for a player' do
  scenario 'Searching for a new player' do
    search('Pentakill')
    expect(page).to have_text('Pentakill')
  end

  scenario 'Searching for a player which does not exist' do
    search('ajsdfoabsdfouabsdfiouweroi')
    expect(page).to have_text('Not Found')
  end
end
