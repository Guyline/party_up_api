class V1::Game::HoldersController < V1::Game::BaseController
  def index
    @users = @game.holders
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/users/index"
  end
end
