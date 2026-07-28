class V1::Item::ExpandablesController < V1::Item::BaseController
  include V1::Concerns::HandlesItems

  protected

  def index_query
    item.expandables
  end
end
