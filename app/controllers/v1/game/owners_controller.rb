class V1::Game::OwnersController < V1::Game::BaseController
  def index
    @users = @game.owners
                  .page(@page)
                  .per(@per_page)
                  .order({ @sort => @order })
    render 'v1/users/index'
  end
end
