Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'signin', to: 'users#signin'
      get 'videos', to: 'videos#show'
      post 'upload', to: 'videos#upload'
      post 'restart', to: 'videos#restart'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
