Lolsummoners::Application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]

  get 'ladders/:id/(:page)', to: 'ladders#show',
                       defaults: { id: 'all', page: 1 },
                             as: 'ladder',
                    constraints: { page: /\d+/ }

  get 'ladders', to: 'ladders#show',
           defaults: { id: 'all', page: 1 }
end
