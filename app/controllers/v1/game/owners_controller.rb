class V1::Game::OwnersController < V1::Game::BaseController
  def index
    @users = @game.owners
                  .page(@page)
                  .per(@per_page)
    render 'users/index'
  end
end
