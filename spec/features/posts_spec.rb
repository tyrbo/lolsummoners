require 'spec_helper'

feature 'User can view posts' do
  before(:each) do
    10.times do
      create(:post)
    end
  end

  scenario 'Viewing the posts index' do
    visit posts_path
    within('div.news:first') do
      expect(page).to have_css('div.title', text: 'Test Post')
    end
  end

  scenario 'Viewing an individual post' do
    visit posts_path
    within('div.news:first') do
      click_link 'Test Post'
    end
    within('div.news') do
      expect(page).to have_css('div.title', text: 'Test Post')
    end
  end

  scenario 'User should only see three posts per page' do
    visit posts_path
    expect(page).to have_css('div.news', count: 3)
  end

  scenario 'User can see older posts' do
    visit posts_path(page: 2)
    expect(page).to have_css('div.news', count: 3)
  end
end
