class V1::Owner::OwnershipsController < V1::Owner::BaseController
  def index
    @ownerships = @owner.ownerships
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/ownerships/index"
  end
end
