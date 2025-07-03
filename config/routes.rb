Rails.application.routes.draw do
  resources :camions do
    collection do
      post :scrape
    end
  end

  # health check, root, etc…
  get "up" => "rails/health#show", as: :rails_health_check
  root "camions#index"
end
