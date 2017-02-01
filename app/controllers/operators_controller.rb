class OperatorsController < ApplicationController
  before_action :check_user_authorization
  before_action :set_operator, only: [:update, :edit, :destroy]

  def index
    @operators = Operator.all
  end

  def create
    @operator = Operator.new(operator_params)
    @operator.tags.select!(&:present?)
    if @operator.save
      redirect_to(operators_path, notice: 'Operator succesfully saved')
    else
      flash.now[:alert] = 'Operator not saved!'
      render :new
    end
  end

  def new
    @operator = Operator.new(tags: [""])
  end

  def edit
  end

  def update
    @operator.assign_attributes(operator_params)
    @operator.tags.select!(&:present?)
    if @operator.save
      redirect_to edit_operator_path(@operator), notice: "Operator Updated"
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Operator'
      render :edit
    end
  end

  def destroy
    @operator.destroy
    redirect_to operators_path, notice: "Operator Deleted"
  end

  private

  def set_operator
    @operator = Operator.friendly.find(params[:id])
  end

  def operator_params
    params.require(:operator).permit(
      :name,
      :status,
      :companyName,
      :code,
      :tradingName,
      :businessNumber,
      :description,
      :tncId,
      :demo,
      :address1,
      :address2,
      :city,
      :state,
      :postcode,
      :latitude,
      :longitude,
      :country,
      :language,
      :contactName,
      :email,
      :phone,
      :fax,
      :website,
      :resContactName,
      :resEmail,
      :resPhone,
      :accountsEmail,
      :currency,
      :logoUrl,
      :tncUrl,
      :contact_job_title,
      :contact_field_office,
      :contract_pdf_file,
      :terms_and_conditions,
      :payment_conditions,
      :google_place_id,
      logo,
      { tags: [] }
    )
  end
end
