ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    
    admin.resources :users
    admin.resources :schools
    admin.resources :piki_entries
    admin.resources :teacher_tickets
    admin.resources :friendships
    admin.connect 'users/:id/:action.:format', :controller => 'users'
    admin.connect 'teachers/:id/:action.:format', :controller => 'teachers'
    admin.connect 'schools/:id/:action.:format', :controller => 'schools'
    admin.connect 'classrooms/:id/:action.:format', :controller => 'classrooms'
    admin.connect 'blogs/:id/:action.:format', :controller => 'blogs'
    admin.root :controller => "dashboard"
    
  end
  
  map.resources :friendships
  map.resources :pictures
  map.resources :schools
  map.resources :users
  map.resources :blogs
  
  map.connect 'users/:id/:action.:format', :controller => 'users'
  map.connect 'teachers/:id/:action.:format', :controller => 'teachers'
  map.connect 'schools/:id/:action.:format', :controller => 'schools'
  map.connect 'classrooms/:id/:action.:format', :controller => 'classrooms'
  map.connect 'blogs/:id/:action.:format', :controller => 'blogs'
  map.connect 'pictures/:id/:action.:format', :controller => 'pictures'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "interface"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
