class V1::Expansion::CopiesController < V1::Expansion::BaseController
  def index
    @copies = @expansion.copies
                        .includes(:playable, :version)
                        .page(@page)
                        .per(@per_page)
                        .order({ @sort => @order })
    render 'v1/copies/index'
  end

  def create
    copy = @expansion.copies.create!(copy_params)
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
