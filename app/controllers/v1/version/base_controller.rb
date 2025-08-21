class V1::Version::BaseController < V1::ApplicationController
  before_action :set_version

  protected

  def version
    @version = Version.find(params[:version_id])
  end
  alias_method :set_version, :version
end
