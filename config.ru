require './app'

# Map the controllers to routes
map('/') { run PagesController }
map('/users') { run UsersController }
map('/games') { run GamesController }
map('/voting') { run VotingController }
map('/results') { run ResultsController }
