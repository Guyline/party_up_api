class V1::Version::CopiesController < V1::Version::BaseController
  def index
    @copies = @version.copies
                      .include(:game, :version)
                      .page(@page)
                      .per(@per_page)
                      .order({ @sort => @order })
    render 'v1/copies/index'
  end

  def create
    copy = @version.copies.create!(copy_params)
    copy.game_id = @version.game_id
    copy.save!

    redirect_to copy
  end

  protected

  def copy_params
    params.require(:copy)
          .permit(
            :holder_id,
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
