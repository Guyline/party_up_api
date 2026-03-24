class V1::User::BaseController < V1::ApplicationController
  protected

  def user
    @user ||= User.find_by!(public_id: params[:user_id])
  end
end
