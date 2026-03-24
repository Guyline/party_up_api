class V1::Copy::BaseController < V1::ApplicationController
  protected

  def copy
    @copy ||= Copy.find_by!(public_id: params[:copy_id])
  end
end
