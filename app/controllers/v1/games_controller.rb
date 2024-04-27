class V1::GamesController < V1::ApplicationController
  def index
    @games = Game.page(@page)
                 .per(@per_page)
  end

  def show
    @game = Game.find(params[:id])
  end
end
