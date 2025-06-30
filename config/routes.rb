Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API routes
  namespace :api do
    namespace :v1 do
      # User Authorization routes
      resources :user_authorizations, only: [:create] do
        collection do
          post :login
        end
      end


    end
  end

end
