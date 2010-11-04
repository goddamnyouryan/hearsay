ActionController::Routing::Routes.draw do |map| 
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.home '/home', :controller => 'home'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.find_friends '/find_friends', :controller => 'users', :action => 'find_friends'
  map.import '/import', :controller => 'users', :action => 'import'
  map.public_stream '/public_stream', :controller => 'home', :action => 'public_stream'
  map.suggestions '/cats/suggestions', :controller => 'cats', :action => 'suggestions'
  map.terms '/terms', :controller => 'sessions', :action => 'terms'
  map.initial_image '/initial_image', :controller => 'images', :action => 'initial_image'
  
  # User Routes
  map.resources :users do |user|
  	user.resources :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }
  	user.resources :friends
  	user.resources :has_many => :cats
  	user.resources :has_many => :answers
  	user.resources :has_many => :votes
  	user.resources :has_many => :comments
  	user.resources :images
  	user.resources :events
  end
  
  # Images routes
 	 map.resources :images, :has_many => :ranks
  
  # Restful Authentication Resources
  map.resources :passwords
  map.resource :session
  
  # Home Page
  map.root :controller => 'sessions', :action => 'new'
  
  # Stuff from the previous version of hearsay
  map.resources :cats, :has_many => :answers
  map.resources :answers, :has_many => :votes
  map.resources :answers, :has_many => :comments
  map.resources :votes
  map.resources :messages
  map.resources :comments
  map.resources :events

	map.connect '/answers/destroy', :controller => 'answers', :action => 'destroy' 
  map.connect '/profile', :controller => 'profile', :action => 'edit'
  map.connect '/users/:id/friends/:user_id', :controller => 'friends', :action => 'update'
  map.connect '/cats/fuck', :controller => 'cats', :action => 'fuck'
  map.connect '/cats/make_public', :controller => 'cats', :action => 'make_public'
  map.connect '/cats/make_private', :controller => 'cats', :action => 'make_private'
  map.connect '/cats/create_suggestions', :controller => 'cats', :action => 'create_suggestions'
  map.connect '/home/friends_stream', :controller => 'home', :action => 'friends_stream'
  map.connect '/comments/explode', :controller => 'cats', :action => 'explode'
  map.connect '/comments/destroy', :controller => 'comments', :action => 'destroy'
  map.connect '/users/:id/friends', :controller => 'users', :has_many => 'friends'
  map.connect '/users/invite', :controller => 'users', :action => 'invite'
  map.user '/:login', :controller => 'users', :action => 'show'
  map.connect '/:login/:id', :controller => 'cats', :action => 'show', :has_many => :answers
  map.connect '/:login/:cat_id', :controller => 'answers', :has_many => :comments
  map.connect '/:login/:events/:id', :controller => 'user', :has_many => :events
  
  

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
