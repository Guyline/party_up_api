class V1::Item::ExpansionsController < V1::Item::BaseController
  def index
    @expansions = @item.expansions
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})

    render "v1/expansions/index"
  end
end
