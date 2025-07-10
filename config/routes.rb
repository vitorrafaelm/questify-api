Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API routes
  namespace :api do
    namespace :v1 do
      get 'questions/index'
      get 'questions/create'
      get 'themes/index'
      get 'themes/create'
      #routes
      resources :themes, only: [:index, :create]
      resources :questions, only: [:index, :create]
      # User Authorization routes
      resources :user_authorizations, only: [:create] do
        collection do
          post :login
        end
      end


    end
  end

end
