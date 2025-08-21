class V1::Version::OwnershipsController < V1::Version::BaseController
  def index
    @ownerships = @version.ownerships
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/ownerships/index"
  end
end
