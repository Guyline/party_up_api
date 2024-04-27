class V1::Game::OwnershipsController < V1::Game::BaseController
  def index
    @ownerships = @game.ownerships
                       .page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
    render 'v1/ownerships/index'
  end
end
