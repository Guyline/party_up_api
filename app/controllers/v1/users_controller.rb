class V1::UsersController < V1::ApplicationController
  def index
    @users = User.page(@page)
                 .per(@per_page)
  end

  def show
    @user = User.find(params[:id])
  end
end
