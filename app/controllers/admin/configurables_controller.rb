class Admin::ConfigurablesController < ApplicationController
	include ConfigurableEngine::ConfigurablesController

	def book_guarantee
	  book_guarantee = Configurable.find_by_name("book_guarantee")
	  if book_guarantee.present?
	  	@global = book_guarantee
	  else
	  	@global = Configurable.new
	  end
	end

	def terms_and_conditions
	  terms_and_conditions = Configurable.find_by_name("terms_and_conditions")
	  if terms_and_conditions.present?
	  	@global = terms_and_conditions
	  else
	  	@global = Configurable.new
	  end
	end

	def create
	  global_setting = Configurable.new(configurable)
	  if global_setting.save
	  	if global_setting.name == "book_guarantee"
	  	  redirect_to(admin_configurable_booking_guarantee_path, notice: 'Booking Guarantee succesfully saved')
	  	elsif global_setting.name == "terms_and_conditions"
	  	  redirect_to(admin_configurable_terms_and_conditions_path, notice: 'Terms and Conditions succesfully saved')
	  	end
	  else
	  	flash.now[:alert] = 'Global Setting not saved!'
	  	redirect_to :back
	  end
	end

	def update
	  global_setting = Configurable.find_by_name(params[:configurable][:name])
      if global_setting.update(configurable)  
        if global_setting.name == "book_guarantee"
          redirect_to(admin_configurable_booking_guarantee_path, notice: 'Booking Guarantee succesfully updated')
	    elsif global_setting.name == "terms_and_conditions"
		  redirect_to(admin_configurable_terms_and_conditions_path, notice: 'Terms and Conditions succesfully saved')
		end
      else
        flash.now[:alert] = 'Sorry, there was an error updating this Configurable'
        redirect_to :back
      end
	end

	private
	  def configurable
	  	params.require(:configurable).permit(:value, :name)
	  end
end
