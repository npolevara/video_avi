Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'signin', to: 'users#signin'
      get 'videos', to: 'videos#show'
      get 'download', to: 'videos#download'
      post 'upload', to: 'videos#upload'
      post 'restart', to: 'videos#restart'
    end
  end

  match '*path', to: 'application#routing_error', via: [:get, :post]
end
