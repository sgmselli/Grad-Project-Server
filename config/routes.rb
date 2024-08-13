Rails.application.routes.draw do
  resources :exercise_sets
  resources :exercises
  resources :workouts
  devise_for :users
  
  namespace :api do
    namespace :v1 do
      resources :workouts do
        collection do
          get 'completed', to: 'workouts#completed'
          get 'incomplete', to: 'workouts#incomplete'
        end
        resources :exercises do
          resources :exercise_sets
        end
      end
      post 'stripe/webhooks', to: 'webhooks#receive'
      post 'stripe/subscribe', to: 'subscriptions#create'
      post 'stripe/checkout', to: 'subscriptions#create_checkout_session'
      get 'exercises/all', to: 'exercises#all'

      get 'auth/subscribed', to: 'sessions#check_subscription'
      get 'auth/validate', to: 'sessions#validate'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
      post 'sign_up', to: 'registrations#create'
    end
  end

end
