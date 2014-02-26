if Rails.env.test?
  $regions = ['test', 'test2']
else
  $regions = ['na', 'euw', 'eune', 'tr', 'br', 'las', 'lan', 'oce', 'ru']
end
