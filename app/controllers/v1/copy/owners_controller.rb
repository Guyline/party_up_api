class V1::Copy::OwnersController < V1::Copy::BaseController
  def index
    @owners = @copy.owners
                   .page(@page)
                   .per(@per_page)
                   .order({ @sort => @order })
    render 'v1/users/index'
  end
end
