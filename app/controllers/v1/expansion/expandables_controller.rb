class V1::Expansion::ExpandablesController < V1::Expansion::BaseController
  def index
    @playables = @expansion.expandables
                           .page(@page)
                           .per(@per_page)
                           .order({ @sort => @order })
    render 'v1/playables/index'
  end
end
