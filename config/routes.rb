Rails.application.routes.draw do
  resources :microposts
  resources :users do
    collection do
      delete :destroy_all
    end
  end
  root "users#index"
end
