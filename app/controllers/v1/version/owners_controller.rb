class V1::Version::OwnersController < V1::Version::BaseController
  def index
    @users = @version.owners
                     .page(@page)
                     .per(@per_page)
                     .order({ @sort => @order })
    render 'v1/users/index'
  end
end
