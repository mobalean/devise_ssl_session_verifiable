Rails.application.routes.draw do
  resources :admins, :only => [:index]
  devise_for :admin, :path => "admin_area", :controllers => { :sessions => :"admins/sessions" }, :skip => :passwords

  match "/admin_area/home", :to => "admins#index", :as => :admin_root

  authenticate(:admin) do
    match "/private", :to => "home#private", :as => :private
  end
end
