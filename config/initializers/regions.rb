if Rails.env.test?
  REGIONS = {
    na: { name: 'North America', hasApi: true },
    euw: { name: 'Europe West', hasApi: true }
  }
else
  REGIONS = {
    na: { name: 'North America', hasApi: true },
    euw: { name: 'Europe West', hasApi: true }
  }
end
