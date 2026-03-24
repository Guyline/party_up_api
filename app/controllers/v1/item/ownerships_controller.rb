class V1::Item::OwnershipsController < V1::Item::BaseController
  include V1::Concerns::HandlesOwnerships

  def index
    super

    render "v1/ownerships/index"
  end

  protected

  def index_query
    item.ownerships
  end
end
