class V1::Version::CopiesController < V1::Version::BaseController
  include V1::Concerns::HandlesCopies

  def index
    @copies = @version.copies
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
    copy = @version.copies.create!(copy_params)
    copy.playable = @version.playable
    copy.save!

    redirect_to copy
  end
end
