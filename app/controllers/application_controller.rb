class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CarrierWave::DownloadError, :with => :carrierwave_download_error

  def carrierwave_download_error
    flash[:error] = "There was an error trying to download that remote file for upload. Please try again or download to your computer first."
    redirect_to :back
  end

  protected

  def configure_permitted_parameters
    [:name].each do |field|
      devise_parameter_sanitizer.for(:sign_up) << field
      devise_parameter_sanitizer.for(:account_update) << field
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
        return "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_white.png')}' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='true' data-switch-image='#{ActionController::Base.helpers.asset_path('star_grey.png')}'>"
      else
        return "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_grey.png')}' data-post-path=#{postPath} data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='false' data-switch-image='#{ActionController::Base.helpers.asset_path('star_white.png')}'>"
      end
    end
      "<img class='like-icon' src='#{ActionController::Base.helpers.asset_path ('star_grey.png')}'>"
  end
end
