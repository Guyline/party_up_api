class V1::Item::HoldersController < V1::Item::BaseController
  def index
    @users = @item.holders
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})

    render "v1/users/index"
  end
end
