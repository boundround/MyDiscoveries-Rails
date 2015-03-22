class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  before_filter :store_location

  def store_location
    session[:user_return_to] = request.fullpath
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation, :avatar)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar)}
  end

  def edit
    @set_body_class = 'passport-page'
    super
  end

  def update
    super
    flash.delete(:notice)
  end

  def new
    @set_body_class = 'passport-page'
    super
    flash.delete(:notice)
  end

  def create
    @set_body_class = 'passport-page'
    super
    flash.delete(:notice)
  end

  protected

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

  def after_sign_in_path_for(resource)
   session[:user_return_to] || request.referrer || root_path
  end

end
