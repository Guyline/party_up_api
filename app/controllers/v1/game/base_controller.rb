class V1::Game::BaseController < V1::ApplicationController
  before_action :set_game

  protected

  def game
    @game = Game.find(params[:game_id])
  end
  alias_method :set_game, :game
end
