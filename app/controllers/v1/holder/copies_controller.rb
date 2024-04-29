class V1::Holder::CopiesController < V1::Holder::BaseController
  def index
    @copies = @holder.held_copies
                     .includes(:playable, :version)
                     .page(@page)
                     .per(@per_page)
                     .order({ @sort => @order })
    render 'v1/copies/index'
  end
end
