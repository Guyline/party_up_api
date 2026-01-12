class V1::Item::OwnershipsController < V1::Item::BaseController
  def index
    @ownerships = @item.ownerships
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})

    render "v1/ownerships/index"
  end
end
