class ProgramsController < ApplicationController

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
#    render plain: params[:program].inspect
    @program = Program.new(program_params)
    @program.save
    redirect_to @program  
  end

  def tags
    params[:sort] ||= "id"
    params[:direction] ||= "asc"
    @programs = Program.order(params[:sort] + " " + params[:direction]).paginate(:per_page => 30, :page => params[:page])
  end
  
  def import
    Program.import(params[:file])
    redirect_to places_path, notice: "Programs imported."
  end

  
  
  private
    def program_params
      params.require(:program).permit(:name, :description, :yearlevelnotes, :cost, :programpath, :heroimagepath, :times, :booknowpath, :contact, :programsubject_list, :programactivity_list, :programyearlevel_list, :tag_list)
    end
end
