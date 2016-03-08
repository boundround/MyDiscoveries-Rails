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

	def stamp_error
	end

	def show
	end

	def create

		# storing the stamp ID - get it from the response
		# make sure the user info is signed in, or log in as guest
		# grab the user unfo from devise
		# when the user stamps the phone, it creates a new record
		# using user_info
		# and guest if not user logged in

		# client = Snowshoe::Client.new(ENV["SNOWSHOE_APP_KEY"], ENV["SNOWSHOE_APP_SECRET"])
		# data = { "data" => params[:data] }
		# response = client.post data
		response = JSON.parse '{ "stamp": { "serial": "26731" }, "receipt": "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "secure": false, "created": "2015-03-24 11:27:33.014149" }'

		if response.include? "stamp" # checking for valid response
			# store it in our database
			# assign the attribute user_info
			if user_signed_in? # active record
				user_info = current_user.id.to_s # a devise method - storing the id
			else
				user_info = "guest"
			end

			# assign stamp id to stamp transaction
			stamp = Stamp.find_by serial: response["stamp"]["serial"]
			stamp_id = stamp.id
			@stamp_transaction = StampTransaction.new(user_info: user_info, stamp_id: stamp_id)
			@place = stamp.place
			if @stamp_transaction.save
				respond_to do |format|
			      format.html
			      format.json { render json: @place }  # respond with the created JSON object
			    end
			end
		else
			respond_to do |format|
				format.html
				format.json { render json: {id: "error"}}
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
		params.require(:stamp_transaction).permit(:stamp_id, :user_info)
	end
end

