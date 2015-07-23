require_relative "../libs"

class CatsController < RailsLite::ControllerBase
  def index
    render :index
  end

  def show
    @cat_id = params[:cat_id]
    render :show
  end
end
