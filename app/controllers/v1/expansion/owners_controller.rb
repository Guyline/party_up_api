class V1::Expansion::OwnersController < V1::Expansion::BaseController
  def index
    @users = @expansion.owners
                       .page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
    render 'v1/users/index'
  end
end
