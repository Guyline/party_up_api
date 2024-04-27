class V1::CopiesController < V1::ApplicationController
  def index
    @copies = Copy.page(@page)
                  .per(@per_page)
  end

  def show
    @copy = Copy.find(params[:id])
  end

  def update
    copy = Copy.find(params[:id])
    copy.update!(copy_params)
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
