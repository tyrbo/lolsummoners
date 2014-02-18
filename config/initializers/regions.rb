if Rails.env.test?
  $regions = ['test']
else
  $regions = ['na', 'euw', 'eune', 'tr', 'br', 'las', 'lan', 'oce', 'ru']
end
