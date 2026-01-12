class V1::Item::OwnersController < V1::Item::BaseController
  def index
    @users = @item.owners
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})

    render "v1/users/index"
  end
end
