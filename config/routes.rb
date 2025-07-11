Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API routes
  namespace :api do
    namespace :v1 do
      get 'class_groups/index'
      get 'class_groups/create'
      get 'class_groups/add_student'
      get 'questions/index'
      get 'questions/create'
      get 'themes/index'
      get 'themes/create'
      #routes
      resources :themes, only: [:index, :create]
      resources :questions, only: [:index, :create]
      resources :class_groups, only: [:index, :create, :show] do
        member do
          post :add_student
          get :with_students
        end
      end
      # User Authorization routes
      resources :user_authorizations, only: [:create] do
        collection do
          post :login
        end
      end


    end
  end

end
