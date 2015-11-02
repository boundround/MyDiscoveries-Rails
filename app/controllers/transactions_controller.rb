class TransactionsController < ApplicationController
  def index
    @set_body_class = 'white-body'
    @transactions = Transaction.all
    @transaction = Transaction.new

    respond_to do |format|
      format.html
      format.json { render json: @transactions }
    end
  end

  def show
    @transaction = Transaction.find(params(:id))

    respond_to do |format|
      format.html
      format.json { render json: @transaction }
    end
  end

  def edit
    @transaction = Transaction.find(params(:id))
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to :back, notice: "Transaction added."
    else
      render :new
    end
  end

  def new
    @transaction = Transaction.new
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to :back, notice: "Transaction deleted"
  end

  def update
  end

  private

    def transaction_params
      params.require(:transaction).permit(:asset_type, :asset_id, :comments, :user_id, :points, :_destroy)
    end
end
