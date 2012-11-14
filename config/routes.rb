HuronCarMatrix::Application.routes.draw do
  resources :projects do
    resources :flights, :except => [:show]
    resources :cars, :except => [:show]
    resources :admin, :only => [:index]
    match "reorganize"  => "projects#reorganize"
  end

  root :to => 'projects#index'
end
