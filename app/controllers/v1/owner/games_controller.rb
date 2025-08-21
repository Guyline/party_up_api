class V1::User::HeldGamesController < V1::Owner::BaseController
  def index
    @games = @owner.held_games
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/games/index"
  end
end
