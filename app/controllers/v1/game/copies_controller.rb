class V1::Game::CopiesController < V1::Game::BaseController
  include V1::Concerns::HandlesCopies

  def index
    @copies = @game.copies
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
    copy = @game.copies.create!(copy_params)
    redirect_to copy
  end
end
