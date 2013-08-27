TimeRecording::Application.routes.draw do
  #get "time_records/index"

  devise_for :users, controllers: { registrations: "registrations" }

  #get "home/index"

  root :to => 'home#index'

  resources :user
  
  resources :time_records do
    collection do
      post 'create_time_record'
      get 'edit_multiple'
      post 'update_multiple'
      post 'create_multiple'
      get 'edit_previous_month_timings'
      post 'update_previous_month_timings'
    end
  end

  resources :admins do
    member do
      get 'approve_user'
      get 'reject_user'
      delete 'destroy_user'
    end
  end


  match 'time_records' => 'time_records#index', as: :user_root
  match 'dashboard' => 'home#dashboard'#, as: :admin_index

  match 'about_us' => 'home#about_us'
  match 'instructions' => 'home#instructions'
  match 'contact' => 'home#contact'

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
