class V1::Expansion::HoldersController < V1::Expansion::BaseController
  def index
    @users = @expansion.holders
                       .page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
    render 'v1/users/index'
  end
end
