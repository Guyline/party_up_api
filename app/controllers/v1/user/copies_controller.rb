class V1::User::CopiesController < V1::User::BaseController
  include V1::Concerns::HandlesCopies

  def index
    super

    render "v1/copies/index"
  end

  protected

  def index_query
    Copy.for_user(user)
  end
end
