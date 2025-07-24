Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API routes
  namespace :api do
    namespace :v1 do
      get 'submissions/show'
      get 'submissions/grade'
      get 'assessment_by_students/index'
      get 'assessment_by_students/submit'
      get 'assessments/create'
      get 'assessments/add_question'
      get 'assessments/assign_to_class_group'
      get 'class_groups/index'
      get 'class_groups/create'
      get 'class_groups/add_student'
      get 'questions/index'
      get 'questions/create'
      get 'themes/index'
      get 'themes/create'
      get 'themes/all', to: 'themes#all_themes'
      #routes
      resources :themes, only: [:index, :create, :destroy, :update]
      resources :questions, only: [:index, :create, :show, :update, :destroy]
      resources :class_groups, only: [:index, :create, :show] do
        member do
          post :add_student
          get :with_students
        end
      end
      resources :assessments, only: [:index, :create, :show, :destroy] do
        member do
          post :add_question
          post :assign_to_class_group
          post :add_students
          delete 'remove_student/:student_id', action: :remove_student
          delete 'remove_question/:question_id', action: :remove_question
          get  :with_questions
        end
      end
      resources :assessment_by_students, only: [:index] do
        member do
          post :submit
        end
      end
      resources :submissions, only: [:show] do
        member do
          patch :grade
        end
      end
      resources :students, only: [:index]
      # User Authorization routes
      resources :user_authorizations, only: [:create] do
        collection do
          post :login
        end
      end


    end
  end

end
