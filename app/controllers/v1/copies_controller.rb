class V1::CopiesController < V1::ApplicationController
  include V1::Concerns::HandlesCopies

  def index
    @copies = Copy.includes(
      :holder,
      :location,
      :playable,
      :version
    )
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
  end

  def show
    @copy = Copy.find(params[:id])
  end

  def update
    copy = Copy.find(params[:id])
    copy.update!(copy_params)
    redirect_to copy
  end
end
