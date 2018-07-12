class ProgramsController < ApplicationController

  before_action :redirect_if_not_admin, :except => [:show]

  def set_program_constants()
    @ylvec = "K,1,2,3,4,5,6,7,8,9,10,11,12"
    @subjects = "Arts, Business & Enterprise, Education, English, Geography, Health & Physical Education, History, Language, Mathematics, Science, Society & Environment, Technology"

  end
  
  def index
    @programs = Program.includes(:webresources).all
  end

  def new
    @program = Program.new
  end

  def show
    @program = Program.includes(:webresources).find(params[:id])
  end

  def edit
    set_program_constants()
    @program = Program.includes(:webresources).find(params[:id])
  end
 
  def update
    @program = Program.find(params[:id])

    if @program.update(program_params)
      redirect_to :back, notice: 'Place succesfully updated'
    else
      redirect_to edit_program_path(@program), notice: 'Error: Place not updated'
    end

  end
    
  def create
    @program = Program.new(program_params)
    @program.save
    redirect_to @program  
  end

  # def tags
  #   params[:sort] ||= "id"
  #   params[:direction] ||= "asc"
  #   @programs = Program.order(params[:sort] + " " + params[:direction]).paginate(:per_page => 30, :page => params[:page])
  # end
  
  def import
    Program.validate_import(params[:file],params[:import])
    redirect_to places_path, notice: "Programs imported."
  end

  def validate_import
    Program.validate_import(params[:file],params[:import])
    redirect_to places_path, notice: "Programs imported."
  end
  
  private
    def program_params
      params.require(:program).permit(:name, :description, :yearlevelnotes, :cost, :programpath, :heroimagepath, :duration, :times, :booknowpath, :contact, :place_id, :programsubject_list, :programactivity_list, :programyearlevel_list, :tag_list)
    end
end
