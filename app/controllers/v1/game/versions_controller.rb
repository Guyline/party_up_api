class V1::Game::VersionsController < V1::Game::BaseController
  def index
    @versions = @game.versions
                     .includes(:playable)
                     .page(@page)
                     .per(@per)
    render 'v1/versions/index'
  end
end
