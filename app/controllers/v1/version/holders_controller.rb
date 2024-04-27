class V1::Version::HoldersController < V1::Version::BaseController
  def index
    @users = @version.holders
                     .page(@page)
                     .per(@per_page)
    render 'users/index'
  end
end
