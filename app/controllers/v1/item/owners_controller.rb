class V1::Item::OwnersController < V1::Item::BaseController
  include V1::Concerns::HandlesUsers

  protected

  def index_query
    item.owners
  end
end
