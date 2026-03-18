class V1::ItemsController < V1::ApplicationController
  def index
    @items = Item
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
      .includes(
        :expandables,
        :expansions
      )
    @total_count = Item.count
  end

  def show
    @item = Item.find_by!(public_id: params[:id])
  end
end
