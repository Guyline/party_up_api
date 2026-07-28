class V1::Item::HoldersController < V1::Item::BaseController
  include V1::Concerns::HandlesUsers

  protected

  def index_query
    item.holders
  end
end
