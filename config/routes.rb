Rails.application.routes.draw do
  namespace :api do
    resources :holdings, only: :create
  end
  ActiveAdmin.routes(self)

  get '/' => redirect('/admin')
end
