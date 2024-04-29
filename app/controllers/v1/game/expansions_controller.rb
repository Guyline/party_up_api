class V1::Game::ExpansionsController < V1::Game::BaseController
  def index
    @expansions = @game.expansions
                       .page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
    render 'v1/expansions/index'
  end
end
