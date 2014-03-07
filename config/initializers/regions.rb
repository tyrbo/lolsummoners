if Rails.env.test?
  REGIONS = {
    test: { name: 'Test', hasApi: true },
    test2: { name: 'Test 2', hasApi: true }
  }
else
  REGIONS = {
    na: { name: 'North America', hasApi: true },
    euw: { name: 'Europe West', hasApi: true }
  }
end
