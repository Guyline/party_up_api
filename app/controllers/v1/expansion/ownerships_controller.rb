class V1::Expansion::OwnershipsController < V1::Expansion::BaseController
  def index
    @ownerships = @expansion.ownerships
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/ownerships/index"
  end
end
