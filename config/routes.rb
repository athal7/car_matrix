CarMatrix::Application.routes.draw do
  resources :flights

  resources :cars
  resources :admin, :only => [:index]
  match 'admin' => 'admin#index'
  match 'reorganize' => 'cars#reorganize'
  match 'car_matrix' => 'cars#car_matrix'
  root :to => 'cars#car_matrix'
end
