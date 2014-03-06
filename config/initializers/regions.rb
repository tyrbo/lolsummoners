if Rails.env.test?
  REGIONS = ['test', 'test2']
else
  REGIONS = ['na', 'euw', 'eune', 'tr', 'br', 'las', 'lan', 'oce', 'ru']
end
