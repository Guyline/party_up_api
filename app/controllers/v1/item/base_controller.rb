class V1::Item::BaseController < V1::ApplicationController
  protected

  def item
    @item = Item.find_by!(public_id: params[:item_id])
  end
end
