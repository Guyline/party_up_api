class V1::Item::CopiesController < V1::Item::BaseController
  include V1::Concerns::HandlesCopies

  def index
    super

    render "v1/copies/index"
  end

  def create
    @copy = index_query.create!(copy_params)

    render "v1/copies/show"
  end

  protected

  def index_query
    item.copies
  end
end
