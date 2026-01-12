class V1::GamesController < V1::ApplicationController
  def index
    @games = Item.games
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/games/index"
  end

  def show
    @game = Item.games.find_by!(public_id: params[:id])
  end
end
