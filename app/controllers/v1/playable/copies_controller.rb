class V1::Playable::CopiesController < V1::Playable::BaseController
  include V1::Concerns::HandlesCopies

  def index
    @copies = @playable.copies
      .includes(
        :holder,
        :location,
        :playable,
        :version
      )
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
    render "v1/copies/index"
  end

  def create
    copy = @playable.copies.create!(copy_params)
    redirect_to copy
  end
end
