class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  # before_action :check_user_authorization
  
  def index
    @authors = Author.all
  end

  def show
    @stories = @author.stories.paginate(page: params[:stories_page], per_page: 3)
  end

  def new
    @author = Author.new()
  end

  def create
    @author = Author.new(author_params)
    
    if @author.save
      respond_to do |format|
        format.html { redirect_to authors_path, notice: 'Author succesfully created.' }
        format.json { render :show, status: :ok, location: @author }
      end
    else
      render action: 'new'
    end
  end

  def edit;end

  def update
    if @author.update(author_params)
      respond_to do |format|
        format.json { render json: @author }
        format.html do
          redirect_to authors_path, notice: 'Author succesfully updated'
        end
      end
    else
      redirect_to :back
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_path, notice: "Author Deleted"
  end

  private
  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :link, :image, :description)
  end

end