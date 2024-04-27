class V1::Copy::OwnershipsController < V1::Copy::BaseController
  def index
    @ownerships = @copy.ownerships
                       .page(@page)
                       .per(@per_page)
    render 'ownerships/index'
  end

  def create
    ownership = @copy.ownerships.create!(ownership_params)
    redirect_to ownership
  end

  protected

  def ownership_params
    params.require(:ownerships)
          .permit(
            :owner_id
          )
  end
end
