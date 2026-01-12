class V1::OwnershipsController < V1::ApplicationController
  def index
    @ownerships = Ownership
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    @total_count = Ownership.count
  end

  def show
    @ownership = Ownership.find_by!(public_id: params[:id])
  end

  def destroy
    ownership = Ownership.find(params[:id])
    ownership.discard
  end
end
