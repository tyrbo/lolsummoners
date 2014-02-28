Lolsummoners::Application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]
  resources :ladders, only: [:show]
#  get 'ladders(/:region(/:page))', to: 'ladders#show',
#                             defaults: { region: 'all', page: 1 },
#                                   as: 'ladders',
#                          constraints: { page: /\d/ }
end
