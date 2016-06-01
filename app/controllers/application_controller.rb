class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # if ENV["BOUNDROUND_ENV"] == "boundround_production"
  #   before_filter :correct_domain!
  # end

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_filter :store_location

  rescue_from CarrierWave::DownloadError, :with => :carrierwave_download_error

  helper Bootsy::Engine.helpers

  def carrierwave_download_error
    flash[:error] = "There was an error trying to download that remote file for upload. Please try again or download to your computer first."
    redirect_to :back
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != "/areas/mapdata.json" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  protected

  def after_sign_in_path_for(resource)
   session[:previous_url] || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :first_name, :last_name, :promo_code, :country, :username,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :first_name, :last_name, :promo_code, :country, :username,
        :email, :password, :password_confirmation, :current_password)
    end
  end

  def redirect_if_not_admin
    if !current_user.try(:admin)
      redirect_to :root, notice: "Not Authorized!"
    end
  end

  def like_icon(content)
    postPath = content.class.to_s.pluralize.downcase + '_' + 'users'
    postType = postPath.singularize
    postType = 'fun_facts_user' if postType == 'funfacts_user'
    postPath = 'fun_facts_users' if postPath == 'funfacts_users'

    if user_signed_in?
      if content.users.include?(current_user)
        return "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_yellow.png')}' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='true' data-switch-image='#{ActionController::Base.helpers.asset_path('star_grey.png')}'>"
      else
        return "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_grey.png')}' data-post-path=#{postPath} data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='false' data-switch-image='#{ActionController::Base.helpers.asset_path('star_yellow.png')}'>"
      end
    end
      "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_grey.png')}'>"
  end

  private
  def correct_domain!
    if request.host == 'app.boundround.com' || request.host == 'boundround.com'
      redirect_to subdomain: "www", :status => 301  # or explicitly 'http://www.mysite.com/'
    end
  end

end
