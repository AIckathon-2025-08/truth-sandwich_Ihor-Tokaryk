require './app'

# Map the controllers to routes
map('/') { run PagesController }
map('/users') { run UsersController }

# You can add more controller mappings here as your app grows
# map('/posts') { run PostsController }
