class V1::Expansion::GamesController < V1::Expansion::BaseController
  def index
    @games = @expansion.expandable_games
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/games/index"
  end
end
