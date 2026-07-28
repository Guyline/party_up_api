class V1::Item::VersionsController < V1::Item::BaseController
  include V1::Concerns::HandlesVersions

  protected

  def index_query
    item.versions
  end
end
