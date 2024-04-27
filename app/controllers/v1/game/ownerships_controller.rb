class V1::Game::OwnershipsController < V1::Game::BaseController
  def index
    @ownerships = @game.ownerships
                       .page(@page)
                       .per(@per_page)
    render 'ownerships/index'
  end
end
