class DiscountsController < ApplicationController

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to :back, notice: "Discount added."
    else
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to :back
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    redirect_to :back, notice: "Discount deleted"
  end

  def import
    Discount.import(params[:file])
    redirect_to :back, notice: "Discounts imported."
  end

  private

    def discount_params
      params.require(:discount).permit(:description, :place_id)
    end


end
