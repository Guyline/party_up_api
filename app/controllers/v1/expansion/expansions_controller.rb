class V1::Expansion::ExpansionsController < V1::Expansion::BaseController
  def index
    @expansions = @expansion.expansions
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/expansions/index"
  end
end
