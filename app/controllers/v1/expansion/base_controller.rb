class V1::Expansion::BaseController < V1::ApplicationController
  before_action :set_expansion

  protected

  def expansion
    @expansion = Playable::Expansion.find(params[:expansion_id])
  end
  alias_method :set_expansion, :expansion
end
