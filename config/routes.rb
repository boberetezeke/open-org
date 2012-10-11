Ooo::Application.routes.draw do
  resources :task_definitions
  resources :organizations
  resources :groups
  resources :tasks

  resources :user_sessions do
    member do
      get 'new'
      post 'create'
      delete 'destroy'
    end
  end
      
  resources :users do
    member do
      get 'edit'
      get 'dashboard'
    end
  end

  root :to => 'users#dashboard'
end
