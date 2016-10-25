class DealsController < ApplicationController
  before_filter :load_dealable

  def new
    @deal = @dealable.deals.new
  end

  def index
    @deals = @dealable.deals
  end

  def show
    @deal = Deal.find(params[:id])
  end

  def create
    @deal = @dealable.deals.new(deal_params)

    if @deal.save
      redirect_to polymorphic_path([@dealable, Deal]), notice: "Deal Created"
    end
  end

  def edit
    @deal = Deal.find(params[:id])
  end

  def update
    @deal = Deal.find(params[:id])
    if @deal.update(deal_params)
      redirect_to polymorphic_path([@dealable, Deal]), notice: "Deal Updated"
    end
  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    redirect_to polymorphic_path([@dealable, Deal]), notice: "Deal Deleted"
  end

  private
    def load_dealable
      resource, id = request.path.split("/")[1, 2]
      @dealable = resource.singularize.classify.constantize.friendly.find(id)
      if @dealable.class.to_s.eql? 'Attraction'
        @attraction = @dealable
      else
        @place = @dealable
      end
    end

    def deal_params
      params.require(:deal).permit(:url, :status, :title, :description, :min_price, :hero_image, :url, :dealable_id, :dealable_id)
    end

end
