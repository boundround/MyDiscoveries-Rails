class PromotionsController < ApplicationController
  before_action -> { check_user_authorization('Spree::Promotion') }
  before_action :set_promotion, except: [:new, :create, :index]
  before_action :set_calculator, only: [:edit, :update]
  before_action :set_active_products, only: [:new, :edit]

  def new
    @promotion = Spree::Promotion.new
    @promotion_action = @promotion.promotion_actions.build(
      type: Spree::Promotion::Actions::CreateAdjustment.to_s
    )
    @calculator_flexi_rate = 50
  end

  def index
    @promotions = Spree::Promotion.all
  end

  def create
    ActiveRecord::Base.transaction do
      @promotion = Spree::Promotion.new(promotion_params)
      if @promotion.save
        create_rules(@promotion)
        create_calculator(@promotion)
        redirect_to(promotions_path, notice: 'Promotion succesfully saved')
      else
        flash.now[:alert] = @promotion.errors.full_messages.join(', ')
        render :new
      end
    end
  end

  def edit
    @promoted_product_ids = @promotion.promotion_rules.first&.products&.map(&:id)
    @calculator_flexi_rate = @calculator.preferences[:amount]
  end

  def update
    ActiveRecord::Base.transaction do
      if @promotion.update(promotion_params)
        update_rules
        update_calculator
        redirect_to(
          promotions_path,
          notice: "Promotion Updated"
        )
      else
        flash.now[:alert] = @promotion.errors.full_messages.join(', ')
        render :edit
      end
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

  def set_active_products
    @active_products = Spree::Product.active
  end

  def create_rules(promotion)
    promotion_rule = Spree::Promotion::Rules::Product.new
    promotion_rule.products = Spree::Product.find(params[:promoted_product_ids])
    promotion.promotion_rules << promotion_rule
  end

  def create_calculator(promotion)
    promotion.promotion_actions.last.calculator = Spree::Calculator::FlexiRatePerItem.new(
      preferred_amount: params[:calculator_flexi_rate].to_f
    )
  end

  def update_rules
    @promotion.promotion_rules.first.products = Spree::Product.find(
      params[:promoted_product_ids]
    )
  end

  def update_calculator
    @calculator.update(
      preferred_amount: params[:calculator_flexi_rate].to_f
    )
  end

  def promotion_params
    params.require(:promotion).permit(
      :id, :name, :code, :description,
      :usage_limit, :starts_at, :expires_at,
      promotion_actions_attributes: [:id, :type]
    )
  end
end
