class V1::User::CopiesController < V1::User::BaseController
  def index
    @copies = @user.copies
                   .page(@page)
                   .per(@per_page)
    render 'copies/index'
  end
end
