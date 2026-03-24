class V1::VersionsController < V1::ApplicationController
  include V1::Concerns::HandlesVersions

  def show
    @version = Version.find_by!(public_id: params[:id])
  end
end
