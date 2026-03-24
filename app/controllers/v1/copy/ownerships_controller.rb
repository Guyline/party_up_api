class V1::Copy::OwnershipsController < V1::Copy::BaseController
  include V1::Concerns::HandlesOwnerships

  def index
    @ownerships = copy.ownerships
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    @total_count = copy.ownerships.count

    render "v1/ownerships/index"
  end

  def create
    ownership = copy.ownerships.create!(ownership_params)
    redirect_to ownership
  end
end
