class V1::Version::OwnersController < V1::Version::BaseController
  def index
    @users = @version.owners
                     .page(@page)
                     .per(@per_page)
    render 'users/index'
  end
end
