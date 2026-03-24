class V1::ItemsController < V1::ApplicationController
  include V1::Concerns::HandlesItems

  def show
    @item = Item.find_by!(public_id: params[:id])
  end

  protected

  def index_query
    Item
  end
end
