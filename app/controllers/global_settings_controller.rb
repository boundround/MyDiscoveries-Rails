class GlobalSettingsController < ApplicationController
	def update_guarantee
		setting = GlobalSetting.new(guarantee_text: params[:guarantee][:guarantee_text])
		if setting.save("book_guarantee")
		  redirect_to(settings_book_guarantee_path, notice: 'Guarantee Text succesfully saved')
		else
		  flash.now[:alert] = 'Guarantee Text not saved!'
          redirect_to settings_book_guarantee_path
		end
	end

	def book_guarantee
		@book_guarantee = GlobalSetting.find("book_guarantee")
	end
end