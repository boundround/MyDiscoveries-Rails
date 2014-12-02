class FunFactsController < ApplicationController
  def new
    @fun_fact = FunFact.new
  end

  def create
    @fun_fact = FunFact.new(fun_fact_params)
    if @fun_fact.save
      redirect_to :back, notice: "fun fact added."
    else
      render :new
    end
  end

  def edit
    @fun_fact = FunFact.find(params[:id])
  end

  def update
    @fun_fact = FunFact.find(params[:id])
    if @fun_fact.update(fun_fact_params)
      redirect_to :back
    end
  end

  def destroy
    @fun_fact = FunFact.find(params[:id])
    @fun_fact.destroy
    redirect_to :back, notice: "fun fact deleted"
  end

  private

    def fun_fact_params
      params.require(:fun_fact).permit(:text, :place_id, :area_id)
    end
end