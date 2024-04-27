class V1::Game::VersionsController < V1::Game::BaseController
  def index
    @versions = @game.versions
                     .page(@page)
                     .per(@per)
    render 'versions/index'
  end
end
