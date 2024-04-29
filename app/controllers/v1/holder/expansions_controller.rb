class V1::Holder::ExpansionsController < V1::Holder::BaseController
  def index
    @expansions = @holder.held_expansions
                         .page(@page)
                         .per(@per_page)
                         .order({ @sort => @order })
    render 'v1/expansions/index'
  end
end
