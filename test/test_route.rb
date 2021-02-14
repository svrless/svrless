require 'svrless'

class TestRoute
  include ResourceGenerator

  resources :post, :comment_resource, :user
end