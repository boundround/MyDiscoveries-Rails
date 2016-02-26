class StampTransactionsController < ApplicationController

	def new
		if params[:stamp_id]
			@stamp_transaction = StampTransaction.new
			@place = Place.find(params[:id])
		else
			@stamp = Stamp.new
			@stamp_transaction = StampTransaction.new
		end
	end

	def stamp_here
	end

	def create
		# client = Snowshoe::Client.new(ENV["SNOWSHOE_APP_KEY"], ENV["SNOWSHOE_APP_SECRET"])
		# data = { "data" => params[:data] }
		# response = client.post data
		response = JSON.parse '{ "stamp": { "serial": "26731" }, "receipt": "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "secure": false, "created": "2015-03-24 11:27:33.014149" }'

		if response.include? "stamp"
			stamp = Stamp.find_by serial: response["stamp"]["serial"]
			@place = stamp.place
			respond_to do |format|
		      format.html
		      format.json { render json: @place }  # respond with the created JSON object
		    end
		end
		
	end

	def destroy
		@stamp_transaction = StampTransaction.find(params[:id])
		@stamp_transaction.destroy
	end

	def edit
	end

	def index
		@stamp_transactions = StampTransaction.all
	end

	def update
		@stamp_transactions = StampTransaction.find(params[:id])

		if @stamp_transactions.update(stamp_params)
			redirect_to :back
		end
	end

	private

	def stamp_transactions_params
		params.require(:stamp).permit(:stamp_id, :user_info)
	end
end

