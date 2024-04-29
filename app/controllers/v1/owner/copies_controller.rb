class V1::Owner::CopiesController < V1::Owner::BaseController
  def index
    @copies = @owner.held_copies
                    .includes(:playable, :version)
                    .page(@page)
                    .per(@per_page)
                    .order({ @sort => @order })
    render 'v1/copies/index'
  end
end
