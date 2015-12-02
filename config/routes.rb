Rails.application.routes.draw do
  root "ladders#show"

  get "/ladders", to: "ladders#show",
    defaults: { region: "all", page: 1 }

  get "/ladders/:region(/:page)", to: "ladders#show",
    defaults: { region: "all", page: 1 },
    as: "ladder",
    constraints: { page: /\d+/ }
end
