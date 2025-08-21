class V1::Playable::VersionsController < V1::Playable::BaseController
  def index
    @versions = @playable.versions
      .includes(:playable)
      .page(@page)
      .per(@per)
    render "v1/versions/index"
  end
end
