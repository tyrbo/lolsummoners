Lolsummoners::Application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]

  get '/ladders/:region(/:page)', to: 'ladders#show',
                       defaults: { region: 'all', page: 1 },
                             as: 'ladder',
                    constraints: { page: /\d+/ }

  get '/ladders', to: 'ladders#show',
           defaults: { region: 'all', page: 1 }

  get '/search', to: 'searches#show'

  get '/player/:region/:summoner_id', to: 'players#show', as: 'player'

  get '/queue/:region/:name', to: 'queues#show'
end
