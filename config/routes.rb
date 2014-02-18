Lolsummoners::Application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]
  get 'ladders/:region', to: 'ladders#show', defaults: { region: 'all' }, as: 'ladder'
end
