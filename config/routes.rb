Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/request' => 'servers#rqst'
  get 'api/serverStatus' => 'servers#status'
  put 'api/kill' => 'servers#kill'
  match '*unmatchedroutes' => 'servers#four_o_four', via: :all
end
