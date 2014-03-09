if Rails.env.test?
  REGIONS = {
    na: { name: 'North America', has_api: true },
    euw: { name: 'Europe West', has_api: false }
  }
else
  REGIONS = {
    na: { name: 'North America', has_api: true },
    euw: { name: 'Europe West', has_api: true }
  }
end
