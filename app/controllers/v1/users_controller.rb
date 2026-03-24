class V1::UsersController < V1::ApplicationController
  include V1::Concerns::HandlesUsers

  def show
    @user = User.find_by!(public_id: params[:id])
  end
end
