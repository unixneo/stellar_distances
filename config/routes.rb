Rails.application.routes.draw do
  root "journeys#index"
  
  get "journeys", to: "journeys#index"
  get "journeys/calculate", to: "journeys#calculate"
  
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
