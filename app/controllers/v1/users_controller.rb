class V1::UsersController < V1::ApplicationController
  include V1::Concerns::HandlesUsers

  def show
    @user = User.find_by!(public_id: params[:id])
    render json: UserSerializer.new(@user).serializable_hash
  end

  protected

  def index_query
    User
  end
end
