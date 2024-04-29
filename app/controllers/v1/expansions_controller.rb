class V1::ExpansionsController < V1::ApplicationController
  def index
    @expansions = Playable::Expansion.page(@page)
                                     .per(@per_page)
                                     .order({ @sort => @order })
  end

  def show
    @expansion = Playable::Expansion.find(params[:id])
  end
end
