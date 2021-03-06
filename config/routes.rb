# -*- encoding : utf-8 -*-
require 'sidekiq/web'
Sub::Application.routes.draw do

  root :to=>'welcome#index'
  get '/welcome/assets'
  get '/deposit' => 'deposit#index'
  get '/iphone' => 'welcome#iphone'
  get '/upload' => 'coursewares#new'
  get '/embed/:id' => 'coursewares#embed'
  get '/edit/:id' => 'coursewares#edit'
  get '/coursewares/:id/edit' => 'courseware#edit'
    
  get '/api/uc' => 'ucenter#ktv_uc_client'
  post '/api/uc' => 'ucenter#ktv_uc_client'
  get '/url' => 'jump_engine#url'
  get '/slide_pic' => 'coursewares#ktvid_slide_pic'
  
  get '/mine' => 'mine#index'
  get '/dashboard' => 'mine#dashboard'
  get '/mine/dashboard'
  get '/mine/my_coursewares'
  get '/mine/view_all_playlists'
  get '/mine/my_coursewares_copyright'
	get '/mine/my_history'
	get '/mine/my_search_history'
  get '/mine/my_bought'
  get '/mine/my_watch_later_coursewares'
  get '/mine/my_favorites'
  get '/mine/my_liked_coursewares'
  get '/mine/my_liked_lists'
  
  # get '/popup/headlines'
  # ________________________________user__________________________________________
  devise_for :users, :path => "account", :controllers => {
      :registrations => :account,
      :confirmations => :account_confirmations,
      :passwords =>  :account_passwords,
      :sessions => :account_sessions,
      :unlocks => :account_unlocks,
      :omniauth_callbacks => "users/omniauth_callbacks"
  }
  devise_scope :user do
    get '/account/auth/spetial' => 'account_sessions#new'
    # finishing reg process
    put '/account/confirmation' => 'account_confirmations#show'
    get "/register", :to => "account#new",as:'register'
    get "/register05", :to => "account#new05"
    get "/register05_temporarily_skip", :to => "account#new05_temporarily_skip"
    get "/register05_force_relogin", :to => "account#new05"
    get "/login", :to => "account_sessions#new",as:'login'
    get '/logout', :to => "account_sessions#destroy", as:'logout'
    # get '/account/edit_pref'
    # get '/account/edit_avatar'
    # get '/account/edit_profile'
    # put '/account/edit_profile' => 'account#update_profile'
    # get '/account/edit_slug'
    # put '/account/edit_slug' => 'account#update_slug'
    # get '/account/edit_notifications'
    # get '/account/edit_banking'
    # get '/account/edit_passwd'
    # get '/account/edit_i18n'
    # get '/account/edit_invite'
    # get '/account/edit_services'
    # get '/account/binds'
    get '/account/bind/:service' => 'account#bind'
    post '/account/bind/:service' => 'account#real_bind'
  end
  match "/account/auth/:provider/unbind", :to => "users#auth_unbind"
  #_______________________________premium__________________________________
  # get "premium" => 'premium#index'
  # get "premium/plans" => 'premium#plans'

  # ________________________________ajax__________________________________________
  post '/ajax/users_follow' => 'users#fol'
  post '/ajax/users_unfollow'=>'users#unfol'
  post '/ajax/get_operation' => 'ajax#get_cw_operation'
  get '/all_unread_notification_num' => 'ajax#all_unread_notification_num'
  get '/ajax/register_huanyihuan'
  post '/ajax/renren_invite'
  get '/ajax/current_user_reg_extent'
  post '/ajax/renren_huanyizhang'
  post '/ajax/renren_real_bind'

  get '/ajax/watch_later'

  get '/presentations/:id/status' => 'ajax#presentations_status'
  get '/ajax/checkUsername'
  get '/ajax/checkEmailAjax'

  post '/ajax/logincheck'
  get '/ajax/get_teachers'
  post '/ajax/get_forum' => 'ajax#get_forum'
  post '/ajax/playlist_sort' => 'ajax#playlist_sort'
  post '/ajax/create_new_playlist' => 'ajax#create_new_playlist'
  post '/ajax/get_share_panel' => 'ajax#get_share_panel'
  post '/ajax/get_share_partial' => 'ajax#get_share_partial'
  post '/ajax/ajax_send_email' =>'ajax#ajax_send_email'
  post '/ajax/flagcw' => 'ajax#flag_cw'
  post '/ajax/get_dynamic_dingcai' => 'ajax#get_dynamic_dingcai'
  post '/ajax/comment_action' => 'ajax#comment_action'
  post '/ajax/get_sorted_playlist' => 'ajax#get_sorted_playlist'
  post '/ajax/add_to_playlist_by_url' => 'ajax#add_to_playlist_by_url'
  post '/ajax/add_to_read_later' => 'ajax#add_to_read_later'
  post '/ajax/get_playlist_share' => 'ajax#get_playlist_share'
  post '/ajax/like_playlist' => 'ajax#like_playlist'
  post '/ajax/get_addto_menu' => 'ajax#get_addto_menu'
  post '/ajax/add_to_read_later_array' =>'ajax#add_to_read_later_array'
  post '/ajax/add_to_playlist_by_id' => 'ajax#add_to_playlist_by_id'
  post '/ajax/create_and_add_to_by_id' => 'ajax#create_and_add_to_by_id'
  post '/ajax/save_note_for_one_cw' => 'ajax#save_note_for_one_cw'
  post '/ajax/add_to_favorites_array' => 'ajax#add_to_favorites_array'
  post '/ajax/remove_ding_array' => 'ajax#remove_ding_array'
  post '/ajax/save_page_to_history' => 'ajax#save_page_to_history'
  post '/ajax/pause_history' => 'ajax#pause_history'
  post '/ajax/remove_one_history' => 'ajax#remove_one_history'
  post '/ajax/clear_history' => 'ajax#clear_history'
  post '/ajax/remove_one_search_history' => 'ajax#remove_one_search_history'
  post '/ajax/pause_search_history' => 'ajax#pause_search_history'
  post '/ajax/clear_search_history' => 'ajax#clear_search_history'
  post '/ajax/delete_upload' => 'ajax#delete_upload'
  post '/ajax/setting_cw_license' => 'ajax#setting_cw_license'
  post '/ajax/enable_beauty_view' => 'ajax#enable_beauty_view'
  post '/ajax/set_privacy' => 'ajax#set_privacy'
  post '/ajax/update_widget_sort' => 'ajax#update_widget_sort'
  post '/ajax/request_widget' => 'ajax#request_widget'
  post '/ajax/update_widget_property' => 'ajax#update_widget_property'
  post '/ajax/bar_update_content_in_playlist' => 'ajax#bar_update_content_in_playlist'
  post '/ajax/bar_request_save_as' =>'ajax#bar_request_save_as'
  post '/ajax/bar_playlist_save_as' => 'ajax#bar_playlist_save_as'
  post '/ajax/bar_request_update_bar' => 'ajax#bar_request_update_bar'
  post '/ajax/bar_delete_one_content' => 'ajax#bar_delete_one_content'
  post '/ajax/bar_undo_delete' => 'ajax#bar_undo_delete'
  post '/ajax/bar_request_playlists' => 'ajax#bar_request_playlists'
  post '/ajax/summonQL' => 'ajax#summonQL'
  post '/ajax/prepare_upload' => 'ajax#prepare_upload'
  post '/upload_page_auto_save' => 'ajax#upload_page_auto_save'
  post '/ajax/unfollow_course' => 'ajax#unfollow_course'
  post '/ajax/follow_course'=> 'ajax#unfollow_course'
  # ________________________________ktv__________________________________________
  get '/welcome/inactive_sign_up'
  get '/welcome/shuffle'
  get '/welcome/latest'
  get '/welcome/feeds'
  resources :play_lists do 
    member do
      post 'handler'
    end
  end
  resources :departments do
    member do
      get "follow"
      get "unfollow"
    end
  end
  resources :courses do 
    collection do
      get 'selectform'
      post 'topicadmin_moderate'
    end
    member do
      get 'coursewares' => 'coursewares#index'
      get 'coursewares_with_page/:page' => 'coursewares#index'
      get "follow"
      get "unfollow"
      get 'syllabus'
      get 'asks'
      get 'experts'
      get 'admin_login'
      post 'admin_loginpost'
      get 'admin_logout'
      post 'forum_topicadmin'
      get 'admin7'
      get 'admin8'
      get 'admin9'
      get 'admin10'
      get 'admin11'
      get 'admin12'
      get 'admin13'
      get 'admin13/post'=>'courses#admin13'
      get 'admin13/recyclebin'=>'courses#admin13'
      get 'admin13/recyclebinpost'=>'courses#admin13'
      get 'admin14'
      get 'admin15'
      get 'admin16'
      get 'admin17'
      get 'admin18'
    end
  end
  get '/coursewares_by_departments' => 'coursewares#index'
  get '/coursewares_by_teachers' => 'coursewares#index'
  get '/coursewares_by_courses' => 'coursewares#index'
  get '/coursewares_with_page' => 'coursewares#index'
  get '/coursewares_with_page/:page' => 'coursewares#index'
  get '/coursewares_mine' => 'coursewares#mine'
  get '/coursewares_mine/:page' => 'coursewares#mine'
  get '/coursewares/:id/revisions/:revision_id' => 'coursewares#show'
  get '/embed/:id/revisions/:revision_id' => 'coursewares#embed'  

  resources :coursewares do
    collection do
      get 'mine'
      get 'latest'
      get 'hot'
    end
    member do
      get 'pay'
      post 'pay_post'
      get 'download'
      post 'download'
      get "thank"
    end
  end
  resources :teachers do
    member do
      get 'coursewares' => 'coursewares#index'
      get 'coursewares_with_page/:page' => 'coursewares#index'
      get "followers"
      get "follow"
      get "unfollow"
      get "courses"
      post "follow" => 'teachers#zm_follow'
      post "unfollow" => 'teachers#zm_unfollow'
    end
  end  
  resources :users do
    collection do
      # get 'hot'
      # get 'invite'
      # post 'invite_submit'
    end
    member do
      get 'coursewares' => 'coursewares#index'
      get 'coursewares_with_page/:page' => 'coursewares#index'
      get "follow"
      post "follow" => 'users#zm_follow'
      post "unfollow" => 'users#zm_unfollow'
      get "unfollow"
      get "followers"
      get "following"
      get "invites"
      get "double_follow"
      # get "following_topics"
      # get "answered"
      # get "asked"
      # get "asked_to"
      # post 'invite_send'
      # get "following_asks"
    end
  end
  resources :comments
  get '/autocomplete/all'
  get '/autocomplete/swords'
  get '/search' => 'search#index'
  get '/search/:q' => 'search#show'
  get '/search_contents/:q' => 'search#show_contents'
  get '/search_playlists/:q' => 'search#show_playlists'
  get '/search_courses/:q' => 'search#show_courses'
  get '/search_teachers/:q' => 'search#show_teachers'
  get '/search_users/:q' => 'search#show_users'
  get '/search_lucky/:q' => 'search#lucky'
  # ________________________________q-n-a__________________________________________
  # get '/home/index',:as=>'home_index'
  # match '/mobile'=>'home#mobile'
  # get '/under_verification' => 'home#under_verification'
  # get '/frozen_page' => 'home#frozen_page'
  # 
  # get '/refresh_sugg' => 'home#refresh_sugg'
  # get '/refresh_sugg_ex' => 'home#refresh_sugg_ex'
  # 
  # get '/bugtrack'=>'application#bugtrack'
  # get '/agreement'=>'home#agreement'
  # get "/traverse/index",as:'traverse'
  # post "/traverse/index",as:'traverse'
  # get "/traverse/asks_from",as:'asks_from'
  # get '/home/agreement'
  # 
  # get '/nb/*file' =>'application#nb'
  # get "/home/index",:as => 'for_help'
  # get '/root'=>'home#index'
  # post '/topics_follow' => 'topics#fol'
  # post '/topics_unfollow'=>'topics#unfol'
  # get '/zero_asks' => 'asks#index',:as => 'zero_asks'
  # 
  # scope 'mobile',:as=>'mobile' do
  #   controller "mobile" do
  #     get 'noticepage'
  #     get 'login'
  #     get 'register'
  #     get 'search'
  #     get 'notifications'
  #   end
  # end
  
  
=begin
  match "/uploads/*path" => "gridfs#serve"
=end
  # match "/update_in_place" => "home#update_in_place"
  # #match "/muted" => "home#muted"
  # match "/newbie" => "home#newbie",:as => :newbie
  # match "/followed" => "home#followed"
  # match "/recommended" => "home#recommended"
  # match "/mark_all_notifies_as_read" => "home#mark_all_notifies_as_read"
  # match "/mark_notifies_as_read" => "home#mark_notifies_as_read"
  # 
  # match "/mute_suggest_item" => "home#mute_suggest_item"
  # match "/report" => "home#report"
  # #match "/about" => "home#about"
  # match "/doing" => "logs#index"
  
  # resources :asks do
  #   member do
  #     get "spam"
  #     get "follow"
  #     get "unfollow"
  #     get "mute"
  #     get "unmute"
  #     post "answer"
  #     post "update_topic"
  #     get "update_topic"
  #     get "redirect"
  #     get "invite_to_answer"
  #     get "share"
  #     post "share"
  #   end
  # end
  # resources :answers do
  #   member do
  #     get "vote"
  #     get "spam"
  #     get "thank"
  #   end
  # end
  
  # resources :topics do #, :constraints => { :id => /[a-zA-Z\w\s\.%\-_]+/ }
  #   collection do
  #     get 'hot'
  #   end
  #   member do
  #     get "follow"
  #     get "unfollow"
  #     post 'update_fathers'
  #     post 'update_title'
  #   end
  # end
  # resources :logs do
  #   collection do
  #     get 'all'
  #   end
  # end
  # resources :inbox
  # 
  # namespace :cpanel do
  #   get "/flagrecords" => 'flag_record#index'
  #   post '/toggle' => 'asks#toggle'
  #   root :to =>  "home#index"
  #   resources :scopes
  #   resources :clients do
  #     put :block, on: :member
  #     put :unblock, on: :member
  #   end
  #   resources :accesses do
  #     put :block, on: :member
  #     put :unblock, on: :member
  #   end
  #   get '/asks_un' => 'asks#index_un'
  # 
  #   get '/asks_un2' => 'asks#index_un2'
  #   get '/answers_un2' => 'answers#index_un2'
  #   get '/comments_un2' => 'comments#index_un2'
  # 
  #   post '/asks_un2all' => 'asks#index_un2all'
  #   post '/answers_un2all' => 'answers#index_un2all'
  #   post '/comments_un2all' => 'comments#index_un2all'
  # 
  #   resources :users
  #   resources :asks do
  #     post :verify, on: :member
  #   end
  #   resources :answers do
  #     post :verify, on: :member
  #   end
  #   resources :topics
  #   resources :comments do
  #     post :verify, on: :member
  #   end
  #   resources :report_spams
  #   resources :notices
  #   get '/oauth' => 'oauth#index',:as=>'oauth'
  #   get '/stats' => 'stats#index',:as=>'stats'
  #   match '/kpi' => 'stats#kpi',:as=>'kpi'
  #   post '/stats/uv' => 'stats#uv'
  #   match "/stats/hot_asks" => "stats#hot_asks"
  #   match "/stats/hot_topics" => "stats#hot_topics"
  #   match "/stats/refresh_asks" => "stats#refresh_asks"
  #   match "/stats/refresh_topics" => "stats#refresh_topics"
  #   post '/stats/edit_hot_asks' => 'stats#edit_hot_asks'
  #   post '/stats/edit_hot_topics' => 'stats#edit_hot_topics'
  #   get '/autofollow' => 'autofollow#index',:as=>'autofollow'
  #   post '/autofollow' => 'autofollow#index_pos',:as=>'autofollow_pos'
  #   delete '/autofollow' => 'autofollow#index_del',:as=>'autofollow_del'
  #   match '/autofollow/verify' => 'autofollow#verify'
  #   match '/autofollow/advertise' => 'autofollow#advertise'
  #   match '/autofollow/ban_word' => 'autofollow#ban_word'
  #   match '/autofollow/deleted' => 'autofollow#deleted'
  #   post '/deal_asks' => 'asks#deal_asks'
  #   post '/deal_answers' => 'answers#deal_answers'
  #   post '/deal_comments' => 'comments#deal_comments'
  #   post '/deal_topics' => 'topics#deal_topics'
  #   post '/deal_report' => 'report_spams#deal_report'
  #   post '/deal_verify' => 'autofollow#deal_verify'
  #   post '/deal_advertise' => 'autofollow#deal_advertise'
  #   post '/deal_word' => 'autofollow#deal_word'
  #   post '/deal_deleted' => 'autofollow#deal_deleted'
  #   post '/autofollow/edit_verify' => 'autofollow#edit_verify'
  #   post '/autofollow/edit_ask_advertise' => 'autofollow#edit_ask_advertise'
  #   post '/autofollow/edit_ac_advertise' => 'autofollow#edit_ac_advertise'
  #   post '/autofollow/create_ban_word' => 'autofollow#create_ban_word'
  #   post '/autofollow/import_ban_word' => 'autofollow#import_ban_word'
  #   match "/welcome" => "users#welcome"
  #   match "/user/avatar_admin"=>"users#avatar_admin"
  #   match "/user/avatar_del"=>"users#avatar_del"
  #   match "/users/:id/edit_admin" => "users#edit_admin"
  #   match "/users/:id/update_admin" => "users#update_admin"
  #   match "/notices/create" => "notices#create"
  # end
  # 
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.super_admin? }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  get "/:whatever" => "application#render_404"
  # 废弃井1-----------------------------------
  # post '/ajax/seg'=>'ajax#seg'
  # 废弃井2-----------------------------------
  # get '/user_logged_in_required'=>'application#user_logged_in_required'
  # get '/modern_required'=>'application#modern_required'
  # get '/ajax/check_fangwendizhi'
  # put '/presentations/:id' => 'ajax#presentations_update'
  # get '/ajax/xl_req_get_method_vod'
  # get '/ajax/star_refresh'
  # post '/presentations' => 'ajax#presentations_upload_finished'
  # resources :notes, :path_prefix => "/coursewares/:id/",
end
