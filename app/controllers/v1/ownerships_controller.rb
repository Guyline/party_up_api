class V1::OwnershipsController < V1::ApplicationController
  def index
    @ownerships = Ownership.page(@page)
                           .per(@per_page)
  end

  def show
    @ownership = Ownership.find(params[:id])
  end

  def destroy
    ownership = Ownership.find(params[:id])
    ownership.discard
  end
end
