Rails.application.routes.draw do
  resources :admins, :only => [:index] do
    get :manual_sign_in, :on => :member
  end
  devise_for :admin, :path => "admin_area", :controllers => { :sessions => :"admins/sessions" }, :skip => :passwords

  get "/admin_area/home", :to => "admins#index", :as => :admin_root

  authenticate(:admin) do
    get "/private", :to => "home#private", :as => :private
  end
end
