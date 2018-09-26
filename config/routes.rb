Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "contributors#search"

  get '/search', to: 'contributors#search'
  post '/index', to: 'contributors#index'
  get '/send_pdf', to: 'contributors#send_pdf'
  get '/send_zip', to: 'contributors#send_zip'
end
