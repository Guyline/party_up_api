class V1::OwnershipsController < V1::ApplicationController
  include V1::Concerns::HandlesOwnerships

  def show
    @ownership = Ownership.find_by!(public_id: params[:id])
  end

  def destroy
    @ownership = Ownership.find_by!(public_id: params[:id])
    ownership.discard
  end

  protected

  def index_query
    Ownership
  end
end
