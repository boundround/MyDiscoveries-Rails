class DiscountsController < ApplicationController
  before_filter :load_discountable

  def index
    @discounts = @discountable.discounts
  end

  def show
    @discounts = @discountable.discounts.new
  end

  def new
    @discount = @discountable.discounts.new
  end

  def create
    @discount = @discountable.discounts.new(discount_params)
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
  end

  private

    def discount_params
      params.require(:discount).permit(:description)
    end

    def load_discountable
      resource, id = request.path.split('/')[1,2]
      @discountable = resource.singularize.classify.constantize.friendly.find(id)
    end

end
