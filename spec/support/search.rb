def search(name)
  visit root_path
  within('#search') do
    select 'NA', from: 'region'
    fill_in 'name', with: name
    click_button 'submit'
  end
end
