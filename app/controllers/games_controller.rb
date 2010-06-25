class GamesController < ApplicationController
  
  def index
    @upcoming_game = Game.upcoming
    
    # the last game played, and the previous 10
    @previous_games = Game.active.previous(:limit => 11)
  end
  
end
