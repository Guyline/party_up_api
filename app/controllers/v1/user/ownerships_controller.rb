class V1::User::OwnershipsController < V1::User::BaseController
  def index
    @ownerships = @user.ownerships
                       .page(@page)
                       .per(@per_page)
    render 'ownerships/index'
  end
end
