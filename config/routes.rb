Rails.application.routes.draw do

  resources :event_logs do
    collection do
      post "insert_log"
    end
  end

  resources :event_reserves

  resources :event_details do
    collection do
      get "start_blog"
      get "blog"
    end
  end
  

  resources :ppomppus
  resources :convenience_items do
    collection do
      get "search"
      get "master_list"
      get "add_keyword"
      delete "delete_keyword"
      get "add_keyword_csv"
      post "insert_keyword_csv"
    end
    member do
      post "insert_keyword"
    end
  end
  
  resources :deal_search_words do
    collection do
      post "add_word"
    end
  end
  
  resources :events do
    collection do
      get "get_event"
      get "event_true"
      get "event_false"
      get "get_event_all"
      get "get_event_eat"
      get "get_event_play"
      get "get_event_movie"
      get "get_event_cafe"
      get "get_hot_all"
      get "get_hot_deal"
      get "get_hot_movie"
      get "get_advance_registration"
      get "get_lottery_event"
      get "add_item"
      get "get_hot_offline"
      get "get_hot_online"
      get "get_new_flg"
      delete "del_new_flg"
      get "new2"
      post "create_event"
      
    end
    member do
      put "show_data"
      put "hide_data"
      put "add_push"
      put "force_data"
      get "edit_data"
    end
  end
  
  resources :event_mailing_lists do
    collection do
      get "all"
      delete "del_mail"
      post "create_ajax"
      put "receive_true"
      put "receive_false"
      post "add_event_site"
      post "create_event_user"
    end
    member do
      post "set_registration_id"
    end
  end

  resources :users do
    member do
      put "set_registration_id"
      get "get_alram_on"
    end
    collection do
      get "agreement"
      get "personal_information_policy"
      get "notice"
    end
  end
  
  resources :feeds do
    collection do
      get   "search_tag"
    end
    member do
      post "add_like"
      post "add_comment"
      get "comment"
    end
  end
  
  resources :populars
  
  resources :alrams do
    collection do
      get "get_alram_data"
      put "phone_alram_on"
      put "phone_alram_off"
    end
  end
  
  resources :member_notes do
    member do
      get "likes"
    end
    collection do
      get "my_content"
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'events#get_event'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
