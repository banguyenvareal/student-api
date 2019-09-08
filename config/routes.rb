Rails.application.routes.draw do
  resources :students
  # mount Api => '/'
  mount Api => '/'
end
