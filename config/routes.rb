ChargifyDemoRails3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  root :to => redirect('/register')
  
  match 'thanks' => 'subscriptions#thanks' #  recieve chargify hook

  devise_for :users, :as => 'account', :controllers => {:sessions => 'devise/sessions'}, :skip => [:sessions]  do
    get  'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    get  'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    
    
    get  'register' => 'devise/registrations#new', :as => :new_user_registration
    post 'register' => 'devise/registrations#create', :as => :user_registration
    
    get  'confirmations/new' => 'devise/confirmations#new', :as => :new_user_confirmation
    post 'confirmations/new' => 'devise/confirmations#create', :as => :user_confirmation
    
    get  'confirmations/:confirmation_token' => 'devise/confirmations#show', :as => :activation
    
    get  'update-account' => 'devise/registrations#edit', :as => :edit_user_registration
    put  'update-account' => 'devise/registrations#update', :as => :edit_user_registration
    
    # redirect after update
    get 'territories', :to => 'territories#index', :as => :user_root
  end
  match '/confirmations', :to => redirect('/confirmations/new')

  resources :territories, :only => [:index, :show]
  resources :routes, :only => [:create, :update, :destroy]

  ##
  # backend
  match '/admin', :to => redirect('/admin/users')

  namespace :admin do
    resources :territories  do
      as_routes
      record_select_routes
      post :mark_all, :on => :collection
    end
    resources :territories_routes, :controller => "territories_routes" do
      as_routes
      record_select_routes
      post :mark_all, :on => :collection
    end
    resources :routes  do
      as_routes
      post :mark_all, :on => :collection
    end
    resources :users  do
      as_routes
      record_select_routes
      post :mark_all, :on => :collection
    end
    resources :users_routes, :controller => "users_routes" do
      as_routes
      record_select_routes
      post :mark_all, :on => :collection
    end
    resources :users_territories, :controller => "users_territories" do
      as_routes
      record_select_routes
      post :mark_all, :on => :collection
    end
    resources :calls do
      as_routes
      post :mark_all, :on => :collection
    end
  end


  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
