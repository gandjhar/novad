class NovelsController < ApplicationController
  def index
    @novels = Novel.all.sort_by { |novel| novel.year }
  end

  def show
    @novel = Novel.find( params[:id] )
  end

  def new
     @novel = Novel.new
     @novel.author_id = params[:author_id]
  end

  def create
     novel = Novel.new( novel_params )

     if novel.save
        redirect_to author_path( novel.author_id )
     else
        render new_novel_path
     end
  end

  def edit
    @novel = Novel.find( params[:id] )
  end

  def update
    @novel = Novel.find( params[:id] )

    if @novel.update_attributes( novel_params )
      redirect_to @novel
    else
      render 'edit'
    end
  end

  def destroy
    @novel = Novel.find( params[:id] )

    author_id = @novel.author_id

    @novel.destroy

    redirect_to author_path( author_id )
  end

  private

  def novel_params
    params.require( :novel ).permit( :title, :year, :cover, :plot, :author_id, genre_ids: [] )
  end


end
