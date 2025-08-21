class V1::Version::HoldersController < V1::Version::BaseController
  def index
    @users = @version.holders
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/users/index"
  end
end
