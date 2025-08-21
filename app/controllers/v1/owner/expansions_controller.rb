class V1::Owner::ExpansionsController < V1::Owner::BaseController
  def index
    @expansions = @owner.held_expansions
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/expansions/index"
  end
end
