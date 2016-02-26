class StampsController < ApplicationController

	def new
		@stamp = Stamp.new
	end

	def create
		@stamp = Stamp.new(stamp_params)
		if @stamp.save
			redirect_to stamps_path
		else
			render action: "new"
		end
	end

	def destroy
		@stamp = Stamp.find(params[:id])
		@stamp.destroy
		redirect_to :back, notice: "Stamp deleted"
	end

	def show
		@stamp = Stamp.find(params[:id])
			render action: "show"
		# end
	end

	def edit
	end

	def update
		@stamp = Stamp.find(params[:id])
		if @stamp.update(stamp_params)
			@stamp.save
		end
	end

	def stamp_error
		redirect_to stamp_transactions_path
	end

	def index
		@stamps = Stamp.all
		# @stamp_transactions = StampTransaction.all
	end

	def new_transaction
		@stamp = Stamp.new
	end

	private

    def stamp_params
      	params.require(:stamp).permit(:serial, :place_id)
  	
  	end
end


