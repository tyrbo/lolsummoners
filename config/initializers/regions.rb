if Rails.env.test?
  REGIONS = {
    na: { name: 'North America', has_api: true },
    euw: { name: 'Europe West', has_api: false },
    oce: { name: 'Oceania', has_api: false }
  }
else
  REGIONS = {
    na: { name: 'North America', has_api: true },
    euw: { name: 'Europe West', has_api: true },
    eune: { name: 'Europe Nordic', has_api: true },
    br: { name: 'Brazil', has_api: true },
    lan: { name: 'LA North', has_api: true },
    las: { name: 'LA South', has_api: true },
    oce: { name: 'Oceania', has_api: true },
    ru: { name: 'Russia', has_api: false },
    tr: { name: 'Turkey', has_api: false }
  }
end
