class V1::User::BaseController < V1::ApplicationController
  before_action :set_user

  protected

  def user
    @user = User.find(params[:user_id])
  end
  alias set_user user
end
