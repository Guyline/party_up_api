class V1::Game::HoldersController < V1::Game::BaseController
  def index
    @users = @game.holders
                  .page(@page)
                  .per(@per_page)
    render 'users/index'
  end
end
