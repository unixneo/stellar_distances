Rails.application.routes.draw do
  root "journeys#index"
  
  # Stellar journey routes (for proxied access via /stellar)
  get "stellar", to: "journeys#index"
  get "stellar/journey", to: "journeys#index"
  get "stellar/journey/calculate", to: "journeys#calculate"
  
  # Direct access routes
  get "journeys", to: "journeys#index"
  get "journey/calculate", to: "journeys#calculate"
  get "journeys/calculate", to: "journeys#calculate"
  
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
