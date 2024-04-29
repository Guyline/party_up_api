class V1::Playable::OwnershipsController < V1::Playable::BaseController
  def index
    @ownerships = @playable.ownerships
                           .page(@page)
                           .per(@per_page)
                           .order({ @sort => @order })
    render 'v1/ownerships/index'
  end
end
