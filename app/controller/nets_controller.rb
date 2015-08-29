require_relative '../libs.rb'

class NetsController < RailsLite::ControllerBase

  def index
    @page_title = "Index Page"
    render :index
  end

  def show
    @page_title = "Show Page"
    @net_id = params[:id]
    render :show
  end

  def new
    @page_title = "New Page"
    render :new
  end

  def create
    # Creation logic here.
  end

  # test customized routes
  def define
    @page_title = "Customized Route"
    render :define
  end
end
