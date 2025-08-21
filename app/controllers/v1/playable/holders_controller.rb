class V1::Playable::HoldersController < V1::Playable::BaseController
  def index
    @users = @playable.holders
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/users/index"
  end
end
