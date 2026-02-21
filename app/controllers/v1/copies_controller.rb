class V1::CopiesController < V1::ApplicationController
  include V1::Concerns::HandlesCopies

  def index
    @copies = Copy
      .includes(:item)
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
      .includes(@includes)
    @total_count = Copy.count
  end

  def show
    @copy = Copy
      .find_by!(public_id: params[:id])
      .includes(@includes)
  end

  def update
    @copy = Copy.find_by!(public_id: params[:id])
    @copy.update!(copy_params)

    render "v1/copies/show"
  end
end
