class V1::CopiesController < V1::ApplicationController
  include V1::Concerns::HandlesCopies

  def show
    @copy = Copy.find_by!(public_id: params[:id])
  end

  def update
    @copy = Copy.find_by!(public_id: params[:id])
    @copy.update!(copy_params)

    render "v1/copies/show"
  end

  protected

  def index_query
    Copy
  end
end
