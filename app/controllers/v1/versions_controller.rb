class V1::VersionsController < V1::ApplicationController
  def index
    @versions = Version.page(@page)
                       .per(@per_page)
                       .order({ @sort => @order })
  end

  def show
    @version = Version.find(params[:id])
  end
end
