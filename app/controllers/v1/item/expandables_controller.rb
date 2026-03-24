class V1::Item::ExpandablesController < V1::Item::BaseController
  include V1::Concerns::HandlesItems

  def index
    super

    render "v1/items/index"
  end

  protected

  def index_query
    item.expandables
  end
end
