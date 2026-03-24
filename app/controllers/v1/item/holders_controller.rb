class V1::Item::HoldersController < V1::Item::BaseController
  include V1::Concerns::HandlesUsers

  def index
    super

    render "v1/users/index"
  end

  protected

  def index_query
    item.holders
  end
end
