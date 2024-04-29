class V1::Game::BaseController < V1::ApplicationController
  before_action :set_game

  protected

  def game
    @game = Playable::Game.find(params[:game_id])
  end
  alias set_game game
end
