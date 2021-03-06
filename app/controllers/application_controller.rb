class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  before_filter :get_header

  if ENV["MYDISCOVERIES_ENV"] == "mydiscoveries_production"
    before_filter :correct_domain!
  end

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_filter :store_location

  rescue_from CarrierWave::DownloadError, :with => :carrierwave_download_error
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper Bootsy::Engine.helpers

  def carrierwave_download_error
    flash[:error] = "There was an error trying to download that remote file for upload. Please try again or download to your computer first."
    redirect_to :back
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (last_url_is_not_auth &&
        # request.path != "/areas/mapdata.json" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def get_header
    @featured_nav_destinations = Place.active.where(show_in_mega_menu: true)
    @featured_nav_offers = Spree::Product.active.where(show_in_mega_menu: true).limit(6)
  end

  protected

  def after_sign_in_path_for(resource)
    if session[:user_return_to].present? && session[:user_return_to].split("/orders/new").size == 2
      session[:user_return_to]
    elsif current_order.present? && current_order.line_items_without_passengers.any?
      line_item = current_order.line_items_without_passengers.last
      line_item_add_passengers_path(line_item.product, line_item)
    elsif session[:previous_url].present?
      session[:previous_url]
    else
      URI(request.referer || '').path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :first_name, :last_name, :promo_code, :country, :username,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :first_name, :last_name, :promo_code, :country, :username,
        :email, :password, :password_confirmation, :current_password)
    end
  end

  def redirect_if_not_admin
    if !current_user.try(:admin)
      redirect_to :root, notice: "Not Authorized!"
    end
  end

  def render_not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.json { head :not_found }
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

  def current_store
    Spree::Store.first
  end

  private
  def correct_domain!
    if request.host == 'mydiscoveries.com.au'
      redirect_to subdomain: "www.mydiscoveries", :status => 301  # or explicitly 'http://www.mysite.com/'
    end
  end

  def last_url_is_not_auth
    request.path != "/users/sign_in" &&
    request.path != "/users/sign_up" &&
    request.path != "/users/password/new" &&
    request.path != "/users/password/edit" &&
    request.path != "/users/confirmation" &&
    request.path != "/users/sign_out"
  end

  def check_user_authorization(model_name = nil)
    model_name = model_name || params[:controller].classify
    authorize model_name.camelize.constantize
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
