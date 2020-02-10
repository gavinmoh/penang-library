Rails.application.routes.draw do
  devise_for :users
  #             path: 'api/v1',
  #             path_names: {
  #               sign_in: 'login',
  #               sign_out: 'logout',
  #               registration: 'signup'
  #             },
  #             controllers: {
  #               sessions: 'sessions',
  #               registrations: 'registrations'
  #             }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "login", to: "sessions#create"
        delete "logout", to: "sessions#destroy"
      end

      resources :books do
        get "search", on: :collection
        post "checkout", on: :member
        put "checkin", on: :member
        get "history", on: :member
      end
    end
  end

end
