Rails.application.routes.draw do
  devise_for :users, path: "auth", path_names: {
                                sign_in: 'login',
                                sign_out: 'logout',
                                registration: 'signup',
                                password: 'password'
                              }, controllers: {
                                sessions: 'users/sessions',
                                registrations: 'users/registrations',
                                passwords: 'users/passwords'
                              }
  
  get '/test', to: 'application#test', defaults: { format: 'json' }
end
