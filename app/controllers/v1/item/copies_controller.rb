class V1::Item::CopiesController < V1::Item::BaseController
  include V1::Concerns::HandlesCopies

  def index
    @copies = @item.copies
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
      .includes(@includes)
    @total_count = @item.copies.count

    render "v1/copies/index"
  end

  def create
    @copy = @item.copies.create!(copy_params)

    render "v1/copies/show"
  end
end
