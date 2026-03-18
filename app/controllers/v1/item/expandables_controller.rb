class V1::Item::ExpandablesController < V1::Item::BaseController
  def index
    base_query = @item.expandables

    @total_count = base_query.count
    @items = base_query
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
      .includes(
        :expandables,
        :expansions
      )

    render "v1/items/index"
  end
end
