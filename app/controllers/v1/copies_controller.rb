class V1::CopiesController < V1::ApplicationController
  include V1::Concerns::HandlesCopies

  def index
    @copies = Copy.includes(
      :holder,
      :item,
      :location,
      :version
    )
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    @total_count = Copy.count
  end

  def show
    @copy = Copy.find_by!(public_id: params[:id])
  end

  def update
    copy = Copy.find_by!(public_id: params[:id])
    copy.update!(copy_params)
    redirect_to copy
  end
end
