class V1::Expansion::VersionsController < V1::Expansion::BaseController
  def index
    @versions = @expansion.versions
      .includes(:playable)
      .page(@page)
      .per(@per)
    render "v1/versions/index"
  end
end
