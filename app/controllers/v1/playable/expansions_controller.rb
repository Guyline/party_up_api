class V1::Playable::ExpansionsController < V1::Playable::BaseController
  def index
    @expansions = @playable.expansions
                           .page(@page)
                           .per(@per_page)
                           .order({ @sort => @order })
    render 'v1/expansions/index'
  end
end
