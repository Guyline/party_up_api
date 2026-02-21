class V1::Item::ExpandablessController < V1::Item::BaseController
  def index
    @items = @item.expandables
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})

    render "v1/items/index"
  end
end
