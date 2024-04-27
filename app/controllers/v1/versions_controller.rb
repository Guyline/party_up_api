class V1::VersionsController < V1::ApplicationController
  def index
    @versions = Version.page(@page)
                       .per(@per_page)
  end

  def show
    @version = Version.find(params[:id])
  end
end
