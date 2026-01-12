class V1::Item::BaseController < V1::ApplicationController
  before_action :set_item

  protected

  def item
    @item = Item.find(params[:item_id])
  end

  alias_method :set_item, :item
end
