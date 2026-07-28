class V1::Item::OwnershipsController < V1::Item::BaseController
  include V1::Concerns::HandlesOwnerships

  protected

  def index_query
    item.ownerships
  end
end
