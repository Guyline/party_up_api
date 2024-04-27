class V1::Game::CopiesController < V1::Game::BaseController
  before_action :set_game

  def index
    @copies = @game.copies
                   .page(@page)
                   .per(@per_page)
    render 'copies/index'
  end

  def create
    copy = @game.copies.create!(copy_params)
    redirect_to copy
  end

  protected

  def copy_params
    params.require(:copy)
          .permit(
            :holder_id,
            :version_id,
            :condition,
            :is_purchaseable,
            :is_tradeable,
            :is_playable,
            :is_borrowable,
            :asking_price,
            :asking_currency
          )
  end
end
