class V1::User::CopiesController < V1::User::BaseController
  def index
    @copies = @user.copies
                   .include(:game, :version)
                   .page(@page)
                   .per(@per_page)
                   .order({ @sort => @order })
    render 'v1/copies/index'
  end
end
