class V1::Item::VersionsController < V1::Item::BaseController
  include V1::Concerns::HandlesVersions

  def index
    super

    render "v1/versions/index"
  end

  protected

  def index_query
    item.versions
  end
end
