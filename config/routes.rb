Rails.application.routes.draw do
  resources :camions do
    collection do
      post :scrape
      post :check_port
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "camions#index"
end
