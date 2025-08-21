class V1::Expansion::CopiesController < V1::Expansion::BaseController
  include V1::Concerns::HandlesCopies

  def index
    @copies = @expansion.copies
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
    copy = @expansion.copies.create!(copy_params)
    redirect_to copy
  end
end
