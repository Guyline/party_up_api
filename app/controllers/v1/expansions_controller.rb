class V1::ExpansionsController < V1::ApplicationController
  def index
    @items = Expansion
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    @total_count = Expansion.count
  end

  def show
    @item = Expansion.find_by!(public_id: params[:id])
  end
end
