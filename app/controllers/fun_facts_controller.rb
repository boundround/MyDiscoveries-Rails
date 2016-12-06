class FunFactsController < ApplicationController

  def index
    @fun_facts = FunFact.where("length(content) > 140").order(:id)
  end

  def all
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      variable = @place
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
      variable = @attraction
    elsif params[:region_id]
      @region = Region.friendly.find(params[:region_id])
      variable = @region
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    end

    @fun_facts = variable.fun_facts
  end

  def new
    @fun_fact = FunFact.new
  end

  def create
    @fun_fact = FunFact.new(fun_fact_params)

    if params[:country_id]
      @fun_fact.countries << Country.friendly.find(params[:country_id])
    end
    if @fun_fact.save
      redirect_to :back, notice: "fun fact added."
    else
      render :new
    end
  end

  def edit
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
    elsif params[:region_id]
      @region = Region.friendly.find(params[:region_id])
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
    end

    @fun_fact = FunFact.find(params[:id])
  end

  def update
    @fun_fact = FunFact.find(params[:id])

    if @fun_fact.update(fun_fact_params)
      @fun_fact.save
    end

    respond_to do |format|
      format.html { redirect_to :back, notice: "fun fact updated" }
      format.json { render json: @fun_fact }
    end
  end

  def destroy
    @fun_fact = FunFact.find(params[:id])
    @fun_fact.destroy
    if params[:region_id]
      @region = Region.friendly.find(params[:region_id])
      redirect_to all_region_fun_facts_path(@region), notice: "fun fact deleted"
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      redirect_to all_country_fun_facts_path(@country), notice: "fun fact deleted"
    elsif params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      redirect_to all_place_fun_facts_path(@place), notice: "fun fact deleted"
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
      redirect_to all_attraction_fun_facts_path(@attraction), notice: "fun fact deleted"
    else
      redirect_to :back, notice: "fun fact deleted"
    end
  end

  def import
    FunFact.import(params[:file])
    redirect_to :back, notice: "Fun Facts imported."
  end

  private

    def fun_fact_params
      params.require(:fun_fact).permit(:content, :reference, :priority, :place_id, :hero_photo, :status, :photo_credit,
                                        :customer_approved, :customer_review, :approved_at, :country_include, :fun_factable_id, :fun_factable_type, :_destroy)
    end
end
