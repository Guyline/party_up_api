class V1::Version::OwnershipsController < V1::Version::BaseController
  def index
    @ownerships = @version.ownerships
                          .page(@page)
                          .per(@per_page)
    render 'ownerships/index'
  end
end
