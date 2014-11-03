if Rails.env.test?
  REGIONS = {
    'na' => { name: 'North America' },
    'euw' => { name: 'Europe West' },
    'oce' => { name: 'Oceania' }
  }
else
  REGIONS = {
    'na' => { name: 'North America' },
    'euw' => { name: 'Europe West' },
    'eune' => { name: 'Europe Nordic' },
    'br' => { name: 'Brazil' },
    'lan' => { name: 'LA North' },
    'las' => { name: 'LA South' },
    'oce' => { name: 'Oceania' },
    'ru' => { name: 'Russia' },
    'tr' => { name: 'Turkey' },
    'kr' => { name: 'Korea' }
  }
end
