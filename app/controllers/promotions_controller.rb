class PromotionsController < ApplicationController
  before_action -> { check_user_authorization('Spree::Promotion') }
  before_action :set_promotion, except: [:new, :create, :index]
  before_action :set_calculator, only: [:edit, :update]

  def show
  end

  def new
    @promotion        = Spree::Promotion.new
    @promotion_action = @promotion.promotion_actions.build(
      type: Spree::Promotion::Actions::CreateAdjustment.to_s
    )
    @calculator_flat_percent = 10
  end

  def index
    @promotions = Spree::Promotion.all
  end

  def create
    @promotion = Spree::Promotion.new(promotion_params)
    if @promotion.save
      @promotion.promotion_actions.last.calculator.update(
        preferred_flat_percent: params[:calculator_flat_percent].to_f
      )
      redirect_to(promotions_path, notice: 'Promotion succesfully saved')
    else
      flash.now[:alert] = @promotion.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @calculator_flat_percent = @calculator.preferences[:flat_percent]
  end

  def update
    if @promotion.update(promotion_params)
      @calculator.update(
        preferred_flat_percent: params[:calculator_flat_percent].to_f
      )
      redirect_to(
        promotions_path,
        notice: "Promotion Updated"
      )
    else
      flash.now[:alert] = @promotion.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @promotion.destroy
    redirect_to(
      promotions_path, notice: 'Promotion deleted'
    )
  end

  private

  def set_promotion
    @promotion = Spree::Promotion.find(params[:id])
  end

  def set_calculator
    @calculator = @promotion.promotion_actions.last.calculator
  end

  def promotion_params
    params.require(:promotion).permit(
      :id,
      :name,
      :code,
      :description,
      :usage_limit,
      :starts_at,
      :expires_at,
      promotion_actions_attributes: [
        :id,
        :type,
        calculator_attributes: [
          :id,
          :preferences
        ]
      ]
    )
  end
end
