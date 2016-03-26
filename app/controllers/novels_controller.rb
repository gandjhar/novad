class NovelsController < ApplicationController
  def index
    @novels = Novel.all.sort_by { |novel| novel.year }
  end

  def show
    @novel = Novel.find( params[:id] )
  end
end
