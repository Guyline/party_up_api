class V1::Playable::OwnersController < V1::Playable::BaseController
  def index
    @users = @playable.owners
                      .page(@page)
                      .per(@per_page)
                      .order({ @sort => @order })
    render 'v1/users/index'
  end
end
