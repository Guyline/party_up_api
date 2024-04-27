class V1::User::OwnershipsController < V1::User::BaseController
  def index
    @ownerships = @user.ownerships
                       .page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
    render 'v1/ownerships/index'
  end
end
