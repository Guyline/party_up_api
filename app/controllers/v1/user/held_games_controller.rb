class V1::User::HeldGamesController < V1::User::BaseController
  def index
    @games = @user.held_games
                  .page(@page)
                  .per(@per_page)
    render 'games/index'
  end
end
