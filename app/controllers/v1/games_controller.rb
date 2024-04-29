class V1::GamesController < V1::ApplicationController
  def index
    @games = Playable::Game.page(@page)
                           .per(@per_page)
                           .order({ @sort => @order })
  end

  def show
    @game = Playable::Game.find(params[:id])
  end
end
